import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String lastMessage;
  final String lastMessageTime;
  final String lastMessageFrom;
  final bool lastMessageSeen;
  final int lastMessageType;
  final int unseenMessages;
  final List users;

  ChatRoomModel(
      {this.lastMessage,
      this.lastMessageTime,
      this.users,
      this.lastMessageType,
      this.lastMessageFrom,
      this.lastMessageSeen,
      this.unseenMessages});

  factory ChatRoomModel.fromDocument(DocumentSnapshot doc) {
    return ChatRoomModel(
        lastMessage: doc.data()["lastMessage"],
        lastMessageTime: doc.data()["lastMessageTime"],
        lastMessageType: doc.data()["lastMessageType"],
        lastMessageFrom: doc.data()["lastMessageFrom"],
        lastMessageSeen: doc.data()["lastMessageSeen"],
        unseenMessages: doc.data()["unseenMessages"],
        users: doc.data()["users"]);
  }
}
