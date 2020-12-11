import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/helpers/algorithms.dart';
import 'package:Prevent/helpers/constants.dart';
import 'package:Prevent/models/chatRoom.dart';
import 'package:Prevent/models/message.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:Prevent/services/database.dart';
import 'package:Prevent/services/localStorage.dart';
import 'package:Prevent/views/chatRoom.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeable/swipeable.dart';

class Conversation extends StatefulWidget {
  final Map chatRoom;

  const Conversation({Key key, this.chatRoom}) : super(key: key);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController _textFieldController = new TextEditingController();
  final FocusNode inputFocusNode = FocusNode();
  bool displaySticker = false;
  bool isLoading = false;
  File imageFile;
  String imageUrl;
  String userId;
  String conversationId = "";
  SharedPreferences preferences;
  final ScrollController listScrollController = ScrollController();
  var listMsg;

  //Swipe variables
  bool showReplyTxt = false;
  bool showReplyImg = false;
  bool showReplySticker = false;
  bool replyIsText = false;
  bool replyIsSticker = false;
  bool replyImgIsSticker = false;
  bool replyIsImage = false;
  String replyMsg = "...";
  String replyImgUrl = "";
  String replyStickerName = "";
  bool replyIsLocal = false;

  String replierName = "Yoo";

  Stream chatMessageStream;

  String lastMsgFrom = "";

  var stickers = [
    {
      "name": "dance",
      "url": "assets/images/dance.gif",
    },
    {
      "name": "anime",
      "url": "assets/images/anime.gif",
    },
    {
      "name": "dead",
      "url": "assets/images/dead.gif",
    },
    {
      "name": "freeSpeech",
      "url": "assets/images/freeSpeech.gif",
    },
    {
      "name": "jackson",
      "url": "assets/images/jackson.gif",
    },
    {
      "name": "love",
      "url": "assets/images/love.gif",
    },
    {
      "name": "money",
      "url": "assets/images/money.gif",
    },
    {
      "name": "wtf",
      "url": "assets/images/wtf.gif",
    },
    {
      "name": "smoker",
      "url": "assets/images/smoker.gif",
    },
  ];

/*
  Widget chatMsgList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageBox(
                    message: snapshot.data.documents[index].data["message"],
                    messageIsLocal:
                        snapshot.data.documents[index].data["sentBy"] ==
                            Constants.localName,
                  );
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }
*/

  showStickers() {
    inputFocusNode.unfocus();
    setState(() {
      displaySticker = !displaySticker;
    });
  }

  Future getImage() async {
    print("get img");
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      Fluttertoast.showToast(msg: "Image Uploading ...");
      uploadImageFile();
    } else {}
  }

  Future uploadImageFile() async {
    print("in upload");
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Chat Images").child(fileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      sendMessage(imageUrl, 1);
      setState(() {
        isLoading = false;
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: " + error);
    });
  }

/*
  getReplierName(){
    print("ooooooooooooooooooooooooooooooook");
    databaseMethods.getChatRoomById(widget.chatRoom["chatRoomId"]).then((val){
      print(val.documents[0].data["users"].toString());
      setState(() {
        replierName = val.documents[0].data["users"].toString();
      });
    });
  }
*/

/*
  sendMessage() {
    if (_textFieldController.text.isNotEmpty) {
      print(
          "msg: ${_textFieldController.text}\nauthor: ${Constants.localName}\nchatid: ${widget.chatRoom["chatRoomId"]}\n");
      String message = _textFieldController.text;

      Map<String, dynamic> msgMap = {
        "message": message,
        "sentBy": Constants.localName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "date": DateTime.now()
      };

      databaseMethods.addMessage(widget.chatRoom["chatRoomId"], msgMap);

      _textFieldController.text = "";
    } else {
      print("weeeeee");
    }
  }
*/

  onFocusChange() {
    if (inputFocusNode.hasFocus) {
      //hide stickers
      setState(() {
        displaySticker = false;
      });
    }
  }

  readLocal() async {
    String targetId = widget.chatRoom["targetId"];
    String id = widget.chatRoom["userId"];

    preferences = await SharedPreferences.getInstance();

    if (id.hashCode <= targetId.hashCode) {
      setState(() {
        conversationId = "$id-$targetId";
      });
    } else {
      setState(() {
        conversationId = "$targetId-$id";
      });
    }

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .update({'chattingWith': targetId});
    await FirebaseFirestore.instance.collection("Users").doc(id).update({
      'friends': FieldValue.arrayUnion([targetId])
    });
    await FirebaseFirestore.instance.collection("Users").doc(targetId).update({
      'friends': FieldValue.arrayUnion([id])
    });
    await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(conversationId)
        .set({
      "users": FieldValue.arrayUnion([id])
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(conversationId)
        .update({
      "users": FieldValue.arrayUnion([targetId])
    });

    setState(() {
      //
    });
  }

  @override
  void initState() {
    /*databaseMethods.getMessages(widget.chatRoom["chatRoomId"]).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });*/
    //getReplierName();
    super.initState();
    inputFocusNode.addListener(onFocusChange);
    displaySticker = false;
    isLoading = false;
    leftSelected = false;
    rightSelected = false;
    readLocal();
  }

  bool leftSelected;
  bool rightSelected;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      backgroundColor: Color(0xffeeebf2),
      appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: "heroAvatar",
                    child: CircleAvatar(
                      backgroundImage: widget.chatRoom["targetAvatar"] != null
                          ? CachedNetworkImageProvider(
                              widget.chatRoom["targetAvatar"])
                          : AssetImage("assets/images/avatar.png"),
                      backgroundColor: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${widget.chatRoom["targetName"]}",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: themeProvider.mode == ThemeMode.light
                                ? Colors.grey[700]
                                : Colors.white),
                      ),
                      SizedBox(height: 1),
                      Text(
                        "Staff",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: themeProvider.mode == ThemeMode.light
                                ? Colors.grey[700]
                                : Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(icon: Icon(Icons.settings), onPressed: () {})
            ],
          )),
      body: WillPopScope(
        onWillPop: onBackPress,
        child: Stack(
          children: <Widget>[
            Container(
                height: hv * 100,
                decoration: BoxDecoration(),
                child: themeProvider.mode == ThemeMode.light
                    ? Image.asset(
                        'assets/images/bg.jpg',
                        repeat: ImageRepeat.repeat,
                      )
                    : Image.asset(
                        'assets/images/dark_bg2.jpg',
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      )),
            themeProvider.mode == ThemeMode.light
                ? Container(
                    color: Color(0xffeeebf2).withOpacity(0.8),
                    height: double.infinity,
                    width: double.infinity,
                  )
                : Container(),
            //Messages
            Column(
              children: <Widget>[
                chatMsgList(),
                isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              margin:
                                  EdgeInsets.only(bottom: 80.0, right: 20.0)),
                        ],
                      )
                    : Container(),
              ],
            ),

            //Input textfield
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                showReplyTxt
                    ? Column(
                        children: <Widget>[
                          Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    MdiIcons.share,
                                    size: 28,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      replyIsLocal
                                          ? "You"
                                          : widget.chatRoom["targetName"],
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      replyMsg,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                )),
                                IconButton(
                                  icon: Icon(MdiIcons.close),
                                  color: themeProvider.mode == ThemeMode.light
                                      ? Colors.grey
                                      : Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      showReplyTxt = false;
                                      replyIsImage = false;
                                      replyIsSticker = false;
                                      replyIsText = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: themeProvider.mode == ThemeMode.light
                                ? Colors.grey[300]
                                : Colors.white24,
                          ),
                        ],
                      )
                    : Container(),
                showReplyImg
                    ? Column(
                        children: <Widget>[
                          Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    MdiIcons.share,
                                    size: 32,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: wv * 2, horizontal: wv * 3),
                                  child: SizedBox(
                                    height: wv * 13,
                                    width: wv * 13,
                                    child: !replyImgIsSticker
                                        ? CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                              padding: EdgeInsets.all(70.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.7),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Material(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.asset(
                                                  "assets/images/not_found.jpeg",
                                                  fit: BoxFit.cover),
                                            ),
                                            imageUrl: replyImgUrl,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "assets/images/$replyImgUrl.gif",
                                            fit: BoxFit.cover,
                                            width: wv * 30),
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      replyIsLocal
                                          ? "You"
                                          : widget.chatRoom["targetName"],
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Image",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                )),
                                IconButton(
                                  icon: Icon(
                                    MdiIcons.close,
                                    color: themeProvider.mode == ThemeMode.dark
                                        ? Colors.white24
                                        : Colors.grey[500],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showReplyImg = false;
                                      replyIsImage = false;
                                      replyIsSticker = false;
                                      replyIsText = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: themeProvider.mode == ThemeMode.dark
                                ? Colors.white24
                                : Colors.grey[300],
                          ),
                        ],
                      )
                    : Container(),

                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      //decoration: BoxDecoration(border: ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: <Widget>[
                                TextField(
                                  scrollPhysics: BouncingScrollPhysics(),
                                  minLines: 1,
                                  maxLines: 5,
                                  focusNode: inputFocusNode,
                                  controller: _textFieldController,
                                  cursorColor: Colors.grey,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.0)),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.0)),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.0)),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: "Message...",
                                    filled: false,
                                    contentPadding: EdgeInsets.only(
                                        bottom: 12, left: 45, right: 40),
                                  ),
                                ),
                                IconButton(
                                  iconSize: 30.0,
                                  color: (themeProvider.mode == ThemeMode.light)
                                      ? Colors.black45
                                      : Colors.grey,
                                  icon: Icon(
                                      themeProvider.mode == ThemeMode.light
                                          ? MdiIcons.emoticon
                                          : MdiIcons.emoticonOutline),
                                  //color: Colors.black45,
                                  enableFeedback: true,
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    showStickers();
                                  },
                                ),
                                Positioned(
                                  right: 0.0,
                                  child: IconButton(
                                    iconSize: 30.0,
                                    icon: Icon(
                                      Icons.image,
                                    ),
                                    color:
                                        (themeProvider.mode == ThemeMode.light)
                                            ? Colors.black45
                                            : Colors.grey,
                                    enableFeedback: true,
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      getImage();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.all(13),
                              child: Icon(
                                Icons.send,
                                size: 20,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            onTap: () async {
                              sendMessage(_textFieldController.text, 0);
                            },
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ],
                      )),
                ),
                //Stickers
                displaySticker ? getStickers() : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }

  int getReplyType() {
    print(replyImgIsSticker.toString());
    return replyIsText ? 0 : (replyImgIsSticker) ? 2 : 1;
  }

  String getReplierId() {
    return replyIsLocal
        ? widget.chatRoom["userId"]
        : widget.chatRoom["targetId"];
  }

  sendMessage(String msg, int type) {
    setState(() {
      showReplyTxt = false;
      showReplyImg = false;
    });
    //0: text     1: image    2: sticker
    if (msg != "") {
      _textFieldController.clear();
      var docRef = FirebaseFirestore.instance
          .collection("Messages")
          .doc(conversationId)
          .collection(conversationId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      setState(() {
        lastMsgFrom = widget.chatRoom["userId"];
      });
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await FirebaseFirestore.instance
            .collection("ChatRooms")
            .doc(conversationId)
            .update({
          'lastMessage': msg,
          "lastMessageType": type,
          "lastMessageTime": DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessageSeen": false,
          "lastMessageFrom": widget.chatRoom["userId"],
          "unseenMessages": FieldValue.increment(1)
        });
        if (replyIsText) {
          transaction.set(docRef, {
            "idFrom": widget.chatRoom["userId"],
            "idTo": widget.chatRoom["targetId"],
            "replierId": getReplierId(),
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "content": msg,
            "type": type,
            "seen": false,
            "replying": true,
            "replyType": getReplyType(),
            "replyContent": replyMsg
          });
        } else if (replyIsImage || replyImgIsSticker) {
          transaction.set(docRef, {
            "idFrom": widget.chatRoom["userId"],
            "idTo": widget.chatRoom["targetId"],
            "replierId": getReplierId(),
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "content": msg,
            "type": type,
            "seen": false,
            "replying": true,
            "replyType": getReplyType(),
            "replyContent": replyImgUrl
          });
        } /*else if (replyIsImage && replyImgIsSticker) {
          transaction.set(docRef, {
            "idFrom": widget.chatRoom["userId"],
            "idTo": widget.chatRoom["targetId"],
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "content": msg,
            "type": type,
            "seen": false,
            "replying": true,
            "replyType": type,
            "replyContent": replyMsg
          });
        }*/
        else {
          transaction.set(docRef, {
            "idFrom": widget.chatRoom["userId"],
            "idTo": widget.chatRoom["targetId"],
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "content": msg,
            "type": type,
            "seen": false,
            "replying": false,
          });
        }
        setState(() {
          replyIsImage = false;
          replyIsSticker = false;
          replyIsText = false;
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: "Empty Message can't be sent.");
    }
  }

  void markMessagesAsSeen() {
    ChatRoomModel conversation = widget.chatRoom["chatRoomData"];
    String userId = widget.chatRoom["userId"];
    String targetId = widget.chatRoom["targetId"];
    print("userId: $userId\n lastMsgFrom: ${conversation.lastMessageFrom}");
    if ((conversation.lastMessageFrom == targetId) && (lastMsgFrom != userId)) {
      FirebaseFirestore.instance
          .collection("ChatRooms")
          .doc(conversationId)
          .set({"lastMessageSeen": true, "unseenMessages": 0},
              SetOptions(merge: true));
    }
  }

  chatMsgList() {
    return Flexible(
        child: (conversationId == "")
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Messages")
                    .doc(conversationId)
                    .collection(conversationId)
                    .orderBy("timeStamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    markMessagesAsSeen();
                    listMsg = snapshot.data.documents;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        controller: listScrollController,
                        padding: displaySticker
                            ? EdgeInsets.only(bottom: !isLoading ? 300 : 5)
                            : EdgeInsets.only(bottom: !isLoading ? 100 : 5),
                        itemCount: snapshot.data.documents.length,
                        reverse: true,
                        itemBuilder: (context, index) => Column(
                              children: <Widget>[
                                createMsgBox(index, listMsg[index]),
                                isLastMsgLeft(index) ? Text("hey") : Container()
                              ],
                            ));
                  }
                },
              ));
  }

  bool isLastMsgRight(int index) {
    if ((index > 0 &&
            listMsg != null &&
            listMsg[index].data()["idFrom"] != userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgLeft(int index) {
    if ((index > 0 &&
            listMsg != null &&
            listMsg[index].data()["idFrom"] == userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget createMsgBox(int index, DocumentSnapshot document) {
    Map<String, dynamic> msgData = {
      "content": document.data()["content"],
      "idFrom": document.data()["idFrom"],
      "idTo": document.data()["idTo"],
      "replyContent": document.data()["replyContent"],
      "replyType": document.data()["replyType"],
      "replying": document.data()["replying"],
      "seen": document.data()["idFrom"],
      "timeStamp": document.data()["idFrom"],
      "type": document.data()["idFrom"],
    };
    MessageModel msgModel = MessageModel.fromDocument(document);
    if (document.data()["type"] == 0) {
      // Text Message
      return (document.data()["idFrom"] == widget.chatRoom["userId"])
          ?
          //My messages
          Swipeable(
              threshold: 50.0,
              onSwipeEnd: () {
                setState(() {
                  replyMsg = document.data()["content"];
                  showReplyTxt = true;
                  showReplyImg = false;
                  showReplySticker = false;
                  replyIsLocal = true;
                  replyIsText = true;
                  replyImgIsSticker = false;
                  replyIsImage = false;
                });
              },
              background: Container(),
              child: MessageBox(
                  replierAvatar: widget.chatRoom["targetAvatar"],
                  message: document.data()["content"],
                  messageIsLocal: true,
                  replierName: widget.chatRoom["targetName"],
                  replierId: widget.chatRoom["targetId"],
                  msgModel: msgModel))
          :
          //Target Messages
          Swipeable(
              threshold: 50.0,
              onSwipeEnd: () {
                print(
                    "replyIsText: $replyIsText replyImgIsSticker: $replyImgIsSticker replyIsImage: $replyIsImage");
                setState(() {
                  replyMsg = document.data()["content"];
                  showReplyTxt = true;
                  replyIsText = true;
                  replyImgIsSticker = false;
                  replyIsImage = false;
                  showReplyImg = false;
                  showReplySticker = false;
                  replyIsLocal = false;
                });
              },
              background: Container(),
              child: MessageBox(
                  localAvatar: widget.chatRoom["localAvatar"],
                  message: document.data()["content"],
                  messageIsLocal: false,
                  replierId: widget.chatRoom["targetId"],
                  replierName: widget.chatRoom["targetName"],
                  msgModel: msgModel),
            );
    } else if (document.data()["type"] == 1) {
      //Images
      return Swipeable(
        threshold: 50,
        background: Container(),
        onSwipeEnd: () {
          print(
              "replyIsText: $replyIsText replyImgIsSticker: $replyImgIsSticker replyIsImage: $replyIsImage");
          (document.data()["idFrom"] == widget.chatRoom["userId"])
              ? setState(() {
                  replyIsLocal = true;
                })
              : setState(() {
                  replyIsLocal = false;
                });
          print("this is $replyIsLocal");
          setState(() {
            replyImgUrl = document.data()["content"];
            showReplyImg = true;
            showReplyTxt = false;
            showReplySticker = false;
            replyImgIsSticker = false;
            replyIsText = false;
            replyImgIsSticker = false;
            replyIsImage = true;
          });
        },
        child: Row(
          mainAxisAlignment:
              document.data()["idFrom"] == widget.chatRoom["userId"]
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 8),
                child: FlatButton(
                    onPressed: () {
                      //url: document.data()["content"]});
                    },
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.7),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset("assets/images/not_found.jpeg",
                              width: 200.0, height: 200.0, fit: BoxFit.cover),
                        ),
                        imageUrl: document.data()["content"],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    )),
                margin: EdgeInsets.only(bottom: 10.0, right: 10.0)),
          ],
        ),
      );
    } else {
      //Stickers
      return Swipeable(
        threshold: 50,
        background: Container(),
        onSwipeEnd: () {
          print(
              "replyIsText: $replyIsText replyImgIsSticker: $replyImgIsSticker replyIsImage: $replyIsImage");
          (document.data()["idFrom"] == widget.chatRoom["userId"])
              ? setState(() {
                  replyIsLocal = true;
                })
              : setState(() {
                  replyIsLocal = false;
                });
          print("this is $replyIsLocal");
          setState(() {
            replyImgUrl = document.data()["content"];
            showReplyImg = true;
            showReplyTxt = false;
            showReplySticker = false;
            replyImgIsSticker = true;
            replyIsText = false;
            replyImgIsSticker = true;
            replyIsImage = false;
          });
        },
        child: Row(
          mainAxisAlignment:
              document.data()["idFrom"] == widget.chatRoom["userId"]
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Image.asset(
                  "assets/images/${document.data()['content']}.gif",
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover),
              margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
            ),
          ],
        ),
      );
    }

    /*if (document.data()["idFrom"] == userId) {
      return Row(
        children: <Widget>[
          document.data()["type"] == 0
              ? Container()
              : document.data()["type"] == 1 ? Container() : Container()
        ],
      );
    } else {
      //
    }*/
  }

  Future<bool> onBackPress() {
    if (displaySticker) {
      setState(() {
        displaySticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  getStickers() {
    final viewInsets = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio);
    return Container(
        decoration: BoxDecoration(
          //border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: EdgeInsets.all(5.0),
        height: MediaQuery.of(context).size.height * 0.35,
        child: GridView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: stickers.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemBuilder: (BuildContext context, int index) {
              return Sticker(
                url: stickers[index]['url'],
                action: () {
                  sendMessage("${stickers[index]['name']}", 2);
                },
              );
            }));
  }
}

class MessageBox extends StatelessWidget {
  final String message;
  final String replierAvatar;
  final String localAvatar;
  final String replierName;
  final String replierId;
  final bool messageIsLocal;
  final Map msgData;
  final MessageModel msgModel;

  const MessageBox(
      {Key key,
      this.message,
      this.messageIsLocal,
      this.msgData,
      this.msgModel,
      this.replierName,
      this.replierId, 
      this.replierAvatar, 
      this.localAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    final themeProvider = Provider.of<ThemeModel>(context);
    var idSet = [msgModel.idFrom, msgModel.idTo];
    String conversationId = Algorithms()
        .getConversationId(userId: msgModel.idFrom, targetId: msgModel.idTo);
    void markSingleMsgAsSeen() {
      String userId =
          Algorithms().getOtherIdFromList(list: idSet, val: replierId);
      DocumentReference msg = FirebaseFirestore.instance
          .collection("Messages")
          .doc(conversationId)
          .collection(conversationId)
          .doc(msgModel.id);
      //print("userId: $userId\n lastMsgFrom: ${conversation.lastMessageFrom}");
      if (msgModel.idFrom == replierId) {
        msg.update({"seen": true});
      }
    }

    return Container(
      padding: EdgeInsets.only(
          top: 5,
          left: messageIsLocal ? 0 : 10,
          right: messageIsLocal ? 10 : 0),
      margin: EdgeInsets.symmetric(vertical: 2),
      width: double.infinity,
      alignment: messageIsLocal ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: wv * 70, minWidth: wv * 23),
            padding: EdgeInsets.only(
                left: wv * 2.5, bottom: hv * 3.7, right: wv * 2, top: hv * 1),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      offset: new Offset(2.0, 2.0),
                      blurRadius: 4.0,
                      spreadRadius: 4.0),
                ],
                color: messageIsLocal
                    ? themeProvider.mode == ThemeMode.light
                        ? Color(0xfffafffa)
                        : Theme.of(context).scaffoldBackgroundColor
                    : Color(0xff605bbd),
                /*gradient: LinearGradient(
                    colors: messageIsLocal
                        ? [const Color(0xfffafffa), const Color(0xfffafffb)]
                        : [const Color(0xff6585D9), const Color(0xff605bbd)]),*/
                borderRadius: messageIsLocal
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        //bottomRight: Radius.circular(10)
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        //bottomLeft: Radius.circular(10),
                      )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                msgModel.replying
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ReplyDialogBox(
                                  name: msgModel.replierId == replierId ? replierName : "You",
                                  content:
                                      msgModel.replyContent,
                                  avatarUrl: localAvatar,
                                  user: Provider.of<UserProfileProvider>(context),
                                );
                              });
                        },
                        child: Container(
                          //width: double.infinity,
                          padding: EdgeInsets.only(
                              left: 10, bottom: 5, right: 5, top: 5),
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            border: Border(
                              left: BorderSide(
                                  color: messageIsLocal
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  width: 3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              (msgModel.replyType == 1) ||
                                      (msgModel.replyType == 2)
                                  ? Container(
                                      width: wv * 15,
                                      height: wv * 15,
                                      padding: EdgeInsets.only(
                                          top: 5, bottom: 5, right: 10),
                                      child: (msgModel.replyType == 1)
                                          ? CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                                padding: EdgeInsets.all(70.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Material(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                                clipBehavior: Clip.hardEdge,
                                                child: Image.asset(
                                                    "assets/images/not_found.jpeg",
                                                    fit: BoxFit.cover),
                                              ),
                                              imageUrl: msgModel.replyContent,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/images/${msgModel.replyContent}.gif",
                                              fit: BoxFit.cover,
                                            ),
                                    )
                                  : Container(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    msgModel.replierId == replierId
                                        ? replierName
                                        : "You",
                                    style: TextStyle(
                                        color: messageIsLocal
                                            ? Theme.of(context).primaryColor
                                            : Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                        right: 10,
                                      ),
                                      constraints: BoxConstraints(
                                          maxWidth: wv * 50, maxHeight: hv * 5),
                                      child: Text(
                                        msgModel.replyType == 0
                                            ? msgModel.replyContent
                                            : msgModel.replyType == 1
                                                ? "Image"
                                                : msgModel.replyType == 2
                                                    ? "Sticker"
                                                    : "content",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: messageIsLocal
                                                ? Colors.grey[400]
                                                : Colors.white),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        width: 1,
                      ),
                Text(
                  message,
                  style: TextStyle(
                      color: !messageIsLocal
                          ? Colors.white
                          : themeProvider.mode == ThemeMode.light
                              ? Colors.black54
                              : Colors.grey[300],
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Positioned(
              right: 5,
              bottom: 5,
              child: Row(
                children: <Widget>[
                  Text(
                    Algorithms().getDateFromTimestamp(
                      int.parse(msgModel.timeStamp),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: !messageIsLocal
                          ? Colors.grey[100]
                          : themeProvider.mode == ThemeMode.light
                              ? Colors.grey[400]
                              : Colors.grey[100],
                    ),
                  ),
                  SizedBox(width: 5),
                  messageIsLocal
                      ? Icon(
                          MdiIcons.checkAll,
                          color: msgModel.seen == true
                              ? Theme.of(context).primaryColor
                              : Colors.grey[400],
                          size: wv * 5,
                        )
                      : Container(),
                ],
              ))
        ],
      ),
    );
  }
}

class ReplyDialogBox extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String content;
  final String contentType;
  final UserProfileProvider user;

  const ReplyDialogBox(
      {Key key, this.name, this.avatarUrl, this.content, this.contentType, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: replyContentBox(context),
    );
  }

  replyContentBox(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    double avatarRadius = wv*10;
    double padding = wv*5;
    return Padding(
      padding: const EdgeInsets.only(bottom: 200.0),
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(minWidth: 300),
            padding: EdgeInsets.only(
                left: padding,
                top: avatarRadius + padding/2,
                right: padding,
                bottom: padding/2),
            margin: EdgeInsets.only(top: avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: new Offset(3.0, 3.0),
                      blurRadius: 2,
                      spreadRadius: 2),
                ],),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  content,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 22,
                ),
                IconButton(icon: Icon(Icons.cancel), onPressed: ()=>Navigator.of(context).pop(),)
              ],
            ),
          ), // bottom part
          Positioned(
            left: padding,
            right: padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: user.getAvatar != null ? CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: CachedNetworkImageProvider(user.getAvatar))
                    : Image.asset('assets/images/avatar.png'),
              ),
            ),
          ) // top part
        ],
      ),
    );
  }
}

class Sticker extends StatelessWidget {
  final String url;
  final Function action;

  const Sticker({Key key, this.url, this.action}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: GestureDetector(
        onTap: action,
        child: Container(
            child: Image.asset(this.url, fit: BoxFit.cover, width: wv * 30)),
      ),
    );
  }
}
