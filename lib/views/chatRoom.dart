import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/helpers/algorithms.dart';
import 'package:Prevent/helpers/constants.dart';
import 'package:Prevent/models/chatRoom.dart';
import 'package:Prevent/models/user.dart';
import 'package:Prevent/providers/guestStatusProvider.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:Prevent/services/auth.dart';
import 'package:Prevent/services/database.dart';
import 'package:Prevent/services/localStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  String userId;
  String userName;
  String avatarUrl;

  chatRoomList() {
    chatRoomStream = FirebaseFirestore.instance
        .collection("ChatRooms")
        .where("users", arrayContains: userId)
        .orderBy("lastMessageTime", descending: true)
        .snapshots();
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.documents.length >= 1 ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot chatRoomSnapshot = snapshot.data.documents[index];
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromDocument(chatRoomSnapshot);
                        List list = chatRoomModel.users;
                        String lastMsg = chatRoomModel.lastMessage;
                        String lastMsgTime = chatRoomModel.lastMessageTime;
                        String friendId = Algorithms().getOtherIdFromList(list: list, val: userId);
                        String conversationId = Algorithms().getConversationId(
                            userId: userId, targetId: friendId);

                        /*
                      dynamic users =
                          snapshot.data.documents[index].data["users"];
                      if (users[0] == Constants.localName) {
                        replier = users[1];
                      } else {
                        replier = users[0];
                      }*/

                        Map<String, dynamic> info = {
                          "targetId": friendId,
                          "localAvatar": avatarUrl,
                          "userId": userId,
                          "chatRoomId": conversationId,
                          "chatRoomModel": chatRoomModel
                        };

                        return chatRoomSnapshot != null
                            ? ChatRoomTile(
                                data: info,
                              )
                            : CircularProgressIndicator();
                      }),
                ) : Column(
                  children: <Widget>[
                    SizedBox(height: 50,),
                    Icon(MdiIcons.databaseSearch, color: Colors.grey[400], size: 85,),
                    SizedBox(height: 5,),
                    Text("Start a conversation", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey[400] ),),
                  ],
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  getUserInfo() async {
    Constants.localName = await LocalStorage.getUserName();
  }

  getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String id = preferences.getString("id");
    String name = preferences.getString("name");
    String avatar = preferences.getString("avatarUrl");

    setState(() {
      userId = id;
      userName = name;
      avatarUrl = avatar;
    });
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Null> logoutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool googleSignInState = await googleSignIn.isSignedIn();
    FirebaseAuth.instance.currentUser;

    if (googleSignInState) {
      await googleSignIn.disconnect();
      await googleSignIn.signOut().catchError((err) {
        print(err.toString());
      });
      Navigator.pushNamedAndRemoveUntil(
          context, '/signIn', (Route<dynamic> route) => false);
      await preferences.clear();
    } else if (auth.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      await preferences.clear();
      Navigator.pushNamedAndRemoveUntil(
          context, '/signIn', (Route<dynamic> route) => false);
    }
    /*await FirebaseAuth.instance.signOut();
    

    Navigator.pushNamedAndRemoveUntil(
        context, '/signIn', (Route<dynamic> route) => false);*/
  }

  @override
  void initState() {
    getUserInfo();
    getUserData();
    databaseMethods.getChatRooms(Constants.localName).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    GuestStatusProvider guestProvider = Provider.of<GuestStatusProvider>(context);
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      //backgroundColor: Colors.grey[100],
      body: !guestProvider.isGuest ? Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: hv * 1.5, horizontal: wv*2),
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              height: hv * 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: themeProvider.mode == ThemeMode.light
                    ? Colors.grey[100]
                    : Colors.black45,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Contact Other Users In The Area",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400])),
                  Hero(child: Icon(Icons.search), tag: "search",),
                ],
              ),
            ),
          ),
          chatRoomList(),
        ],
      )
      :
      Center(
        child: RaisedButton(
          child: Text("Sign In Before Accessing Chatroom", style: TextStyle(color: Colors.white),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
          }
        ),
      ),

      /*floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          }),*/
    );
  }
}

class ChatRoomTile extends StatefulWidget {
  final String username;
  final Map data;

  const ChatRoomTile({Key key, this.username, this.data}) : super(key: key);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    ChatRoomModel chatRoom = widget.data["chatRoomModel"];
    bool isLocal = chatRoom.lastMessageFrom != widget.data["targetId"];
    var query = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.data["targetId"])
        .snapshots();
    return StreamBuilder<Object>(
        stream: query,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }
          AppUser chatBuddy = AppUser.fromDocument(snapshot.data);
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
                decoration: BoxDecoration(
                    //border: Border.all(color: Colors.grey[200]),
                    /*boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: new Offset(2.0, 2.0),
                        blurRadius: 4.0,
                        spreadRadius: 4.0),
                ],*/
                    //color: Colors.white, borderRadius: BorderRadius.circular(12.0)
                    //border: Border(bottom: BorderSide(color: Colors.grey[200])),
                    ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: chatBuddy.avatarUrl != null
                        ? CachedNetworkImageProvider(chatBuddy.avatarUrl)
                        : AssetImage("assets/images/avatar.png"),
                  ),
                  title: Text(chatBuddy.name != null ? chatBuddy.name : "wait"),
                  subtitle: chatRoom.lastMessageType == 0
                      ? Row(
                          children: <Widget>[
                            isLocal ? Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Icon(
                                MdiIcons.checkAll,
                                color: chatRoom.lastMessageSeen ? Theme.of(context).primaryColor : Colors.grey[400],
                                size: 17,
                              ),
                            ) : Container(),
                            SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                chatRoom.lastMessage != null
                                    ? chatRoom.lastMessage
                                    : "wait",
                                style: TextStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : chatRoom.lastMessageType == 1
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Row(
                                children: <Widget>[
                                  isLocal ? Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Icon(
                                      MdiIcons.checkAll,
                                      color: Colors.grey[400],
                                      size: 17,
                                    ),
                                  ) : Container(),
                                  Icon(
                                    MdiIcons.image,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Image")
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Row(
                                children: <Widget>[
                                  isLocal ? Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Icon(
                                      MdiIcons.checkAll,
                                      color: Colors.grey[400],
                                      size: 17,
                                    ),
                                  ) : Container(),
                                  SizedBox(width: 3),
                                  Icon(
                                    MdiIcons.sticker,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Sticker")
                                ],
                              ),
                            ),
                  //subtitle: Text("Joined: " + DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch((int.parse(user.createdAt))))),
                  trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Text(
                        chatRoom.lastMessageTime != null
                            ? Algorithms().getDateFromTimestamp(
                                int.parse(chatRoom.lastMessageTime),
                              )
                            : "wait",
                        style: TextStyle(fontSize: 13, color: themeProvider.mode == ThemeMode.light ?  Colors.grey[600] : Colors.white),),
                    SizedBox(height: 5,),
                    !isLocal ? 
                    chatRoom.unseenMessages != null ?
                      chatRoom.unseenMessages > 0 ?
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(chatRoom.unseenMessages.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.white))
                      )
                      : Text("") : Text("") : Text(""),
                  ],),
                  
                  onTap: () {
                    Map<String, dynamic> chatRoom = {
                      "targetId": widget.data["targetId"],
                      "targetAvatar": chatBuddy.avatarUrl,
                      "targetName": chatBuddy.name,
                      "userId": widget.data["userId"],
                      "chatRoomData": widget.data["chatRoomModel"]
                    };
                    Navigator.pushNamed(context, '/conversation',
                        arguments: chatRoom);
                  },
                ),
              ),
              Divider(height: 0)
            ],
          );
        });
  }
}
