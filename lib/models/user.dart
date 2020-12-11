import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final List skillSet;
  final String phone;
  final String title;
  final String aboutMe;
  final List friends;
  final bool isStaff;
  final String avatarUrl;
  final String createdAt;

  AppUser(
      {this.id,
      this.name,
      this.email,
      this.avatarUrl,
      this.aboutMe,
      this.createdAt,
      this.phone,
      this.title,
      this.isStaff,
      this.friends,
      this.skillSet});

  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
        id: doc.id,
        name: doc.data()["username"],
        skillSet: doc.data()["skillSet"],
        email: doc.data()["email"],
        phone: doc.data()["phone"],
        title: doc.data()["title"],
        isStaff: doc.data()["isStaff"],
        aboutMe: doc.data()["aboutMe"],
        friends: doc.data()["friends"],
        avatarUrl: doc.data()["avatarUrl"],
        createdAt: doc.data()["createdAt"]);
  }
}
