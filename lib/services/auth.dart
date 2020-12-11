import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/helpers/algorithms.dart';
import 'package:Prevent/models/user.dart';
import 'package:Prevent/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences preferences;
  Color red = Colors.red;
  Color white = Colors.white;

  AppUser _userFromFirebaseuser(User user) {
    return user != null ? AppUser(id: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      var data = DatabaseMethods().getUserById(firebaseUser.uid);
      await preferences.setString("id", firebaseUser.uid);
      await preferences.setString("name", data["username"]);
      await preferences.setString("email", email);
      await preferences.setString("avatarUrl", data["avatarUrl"]);
      await preferences.setString("aboutMe", data["aboutMe"]);
      return firebaseUser;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: red,
        textColor: white,
      );
    }
  }

  Future signUpwithEmailAndPassword(String username, String email,
      String password, BuildContext context) async {
    UserCredential result;
    preferences = await SharedPreferences.getInstance();
    try {
      result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((currentUser) async {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.user.uid)
            .set({
          "username": username,
          "avatarUrl": null,
          "email": email,
          "id": currentUser.user.uid,
          "aboutMe": "Hey, I'm new here.",
          "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingWith": null,
          "keyWords": Algorithms().getKeyWords(username)
        });
        Fluttertoast.showToast(
          msg: "User " + username + " Registered successfully",
          backgroundColor: Color(0xFF605BBD),
          textColor: white,
        );
        var data = await DatabaseMethods().getUserById(currentUser.user.uid);
        await preferences.setString("id", currentUser.user.uid);
        await preferences.setString("name", username);
        await preferences.setString("email", email);
        await preferences.setString("avatarUrl", data["avatarUrl"]);
        await preferences.setString("aboutMe", data["aboutMe"]);
        Navigator.pushReplacementNamed(context, "/chatRoom");
        return currentUser.user;
      }).then((res) {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: 'The password provided is too weak.',
          backgroundColor: red,
          textColor: white,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'The account already exists for that email.',
          backgroundColor: red,
          textColor: white,
        );
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: red,
        textColor: white,
      );
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
