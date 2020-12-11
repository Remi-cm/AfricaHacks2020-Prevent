import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/helpers/algorithms.dart';
import 'package:Prevent/helpers/constants.dart';
import 'package:Prevent/models/chatRoom.dart';
import 'package:Prevent/models/user.dart';
import 'package:Prevent/services/database.dart';
import 'package:Prevent/theming/colors.dart';
import 'package:Prevent/views/components/formTools.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String userId;
  String userName;
  String avatarUrl;

  DatabaseMethods _databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  TextEditingController _searchController = new TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  SharedPreferences preferences;

  void getUserData() async {
    preferences = await SharedPreferences.getInstance();
    String id = preferences.getString("id");
    String url = preferences.getString("avatarUrl");

    setState(() {
      userId = id;
      avatarUrl = url;
    });
  }

/*
  // ChatRoom Creation
  createChatroomAndStartConversation(String username) async {
    String chatRoomId = getChatRoomId(username, Constants.localName);

    List<String> users = [username, Constants.localName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId
    };

    Map<String, dynamic> chatRoom = {
      "replierName": username,
      "chatRoomId": chatRoomId
    };

    await _databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.pushNamed(context, '/conversation', arguments: chatRoom);
  }
*/
  searchResults() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<SearchResult> searchUserResult = [];
        dataSnapshot.data.documents.forEach((document) {
          AppUser singleUser = AppUser.fromDocument(document);
          SearchResult userResult = SearchResult(user: singleUser);

          if (userId != document["id"]) {
            searchUserResult.add(userResult);
          }
        });

        return ListView(
          children: searchUserResult,
        );
      },
    );
  }

  searches() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .where("keyWords",
              arrayContains: _searchController.text.toLowerCase())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data.documents.length >= 1 ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot user = snapshot.data.documents[index];
            AppUser singleUser = AppUser.fromDocument(user);
            if (singleUser.id == userId) {
              return Container();
            }
            return SearchResult(
              user: singleUser,
              userId: userId,
              userAvatar: avatarUrl,
            );
          },
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(MdiIcons.databaseRemove, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text("No advisors with name :\n \"${_searchController.text}\"", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      },
    );
  }
/*
  search() {
    _databaseMethods.getUserByUsername(_searchController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }
*/

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      //backgroundColor: Color(0xffeeebf2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            InkWell(
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
            SizedBox(
              width: 0,
            ),
            Expanded(
              child: Container(
                height: 45,
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),

                // TextField
                child: TextField(
                  autofocus: true,
                  controller: _searchController,
                  onChanged: (val) {
                    searchUsers(val);
                  },
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter the name..",
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(bottom: 12, left: 15, right: 15),

                    /*prefixIcon: IconButton(icon :Icon(Icons.arrow_back_ios), enableFeedback: false, 
                    onPressed: (){Navigator.pop(context);},),*/
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 7)
          ],
        ),
      ),
      body: (_searchController.text != "")
          ? Container(
              padding:
                  EdgeInsets.symmetric(vertical: hv * 2, horizontal: hv * 2),
              child: searches())
          : noUsers(context),
    );
  }

  searchUsers(String keyWord) {
    Future<QuerySnapshot> allFoundUsers = FirebaseFirestore.instance
        .collection("Users")
        .where("keyWords", arrayContains: keyWord.toLowerCase())
        .get();

    setState(() {
      futureSearchResults = allFoundUsers;
    });
  }

  Widget noUsers(context) {
    final hv = MediaQuery.of(context).size.height / 100;
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: hv * 30),
          Hero(
            tag: "search",
            child: Icon(
              Icons.search,
              size: hv * 10,
              color: Colors.grey,
            ),
          ),
          Text(
            "Find Freelance Advisors",
            style: TextStyle(
                fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  final AppUser user;
  final String userId;
  final String userName;
  final String userAvatar;
  final String userEmail;
  final Function onTap;

  const SearchResult({
    Key key,
    this.userName,
    this.userEmail,
    this.onTap,
    this.user,
    this.userId, 
    this.userAvatar,
  }) : super(key: key);

  ChatRoomModel getChatRoom() {
    ChatRoomModel chatRoomModel = ChatRoomModel();
    String conversationId =
        Algorithms().getConversationId(userId: userId, targetId: user.id);
    FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(conversationId)
        .get()
        .then((conversation) {
      ChatRoomModel chatRoom = ChatRoomModel.fromDocument(conversation);
      chatRoomModel = chatRoom;
    });
    return chatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    ChatRoomModel chatRoomData = ChatRoomModel(lastMessageFrom: userId);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: user.avatarUrl != null
              ? CachedNetworkImageProvider(user.avatarUrl)
              : AssetImage("assets/images/avatar.png"),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        //subtitle: Text("Joined: " + DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch((int.parse(user.createdAt))))),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
        ),
        onTap: () {
          startConversation(context, chatRoomData);
        },
      ),
    );
  }

  startConversation(BuildContext context, ChatRoomModel chatRoomData) {
    Map<String, dynamic> chatRoom = {
      "targetId": user.id,
      "targetAvatar": user.avatarUrl,
      "localAvatar" : userAvatar,
      "targetName": user.name,
      "userId": userId,
      "chatRoomData": chatRoomData
    };
    Navigator.pushNamed(context, '/conversation', arguments: chatRoom);
  }
}

/*
getChatRoomId(String a, String b) {
  if (a.length == b.length) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  } else if (a.length < b.length) {
    return "$a\_$b";
  } else {
    return "$b\_$a";
  }
}
*/

/*
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0x0fffffff),
                const Color(0xffa4aba6).withOpacity(0.3),
                const Color(0xffa4aba6).withOpacity(0.0),
              ])
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Type and search a user name",
                filled: true,
                prefixIcon: IconButton(icon :Icon(Icons.arrow_back_ios), enableFeedback: false, 
                onPressed: (){Navigator.pop(context);},),
                suffixIcon: IconButton(icon :Icon(Icons.search), 
                onPressed: (){
                  search();
                },),
              ),
            ),
          ),*/
