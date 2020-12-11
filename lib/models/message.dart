import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String idFrom;
  final String idTo;
  final String replierId;
  final String replyContent;
  final int replyType;
  final bool replying;
  final bool seen;
  final String timeStamp;
  final int type;
  MessageModel(
      {this.id,
      this.idFrom,
      this.idTo,
      this.replierId,
      this.replyContent,
      this.replyType,
      this.replying,
      this.seen,
      this.timeStamp,
      this.type});

  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    return MessageModel(
      id: doc.id,
      idFrom: doc.data()["idFrom"],
      idTo: doc.data()["idTo"],
      replierId: doc.data()["replierId"],
      replyContent: doc.data()["replyContent"],
      replyType: doc.data()["replyType"],
      replying: doc.data()["replying"],
      seen: doc.data()["seen"],
      timeStamp: doc.data()["timeStamp"],
      type: doc.data()["type"],
    );
  }
}
