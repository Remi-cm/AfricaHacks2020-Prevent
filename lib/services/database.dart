import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserById(String id) async {
    return await FirebaseFirestore.instance.collection("Users").doc(id).get();
  }
  getUserById2(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("Users").doc(id).get();
    return doc;
  }

  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("Users")
        .where("username", isEqualTo: username)
        .getDocuments();
  }

  getUserByEmail(String email) async {
    return await Firestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("Users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("Chatroom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChatRoomById(String chatRoomId) async {
    return await Firestore.instance
        .collection("Chatroom")
        .where("chatroomId", isEqualTo: chatRoomId)
        .getDocuments();
  }

  addMessage(String chatRoomId, Map msgMap) {
    Firestore.instance
        .collection("Chatroom")
        .document(chatRoomId)
        .collection("chats")
        .add(msgMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection("Chatroom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("date")
        .snapshots();
  }

  getChatRooms(String username) async {
    return Firestore.instance
        .collection("Chatroom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
