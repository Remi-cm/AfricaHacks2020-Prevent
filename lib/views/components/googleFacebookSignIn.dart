import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAndFacebookSignIn extends StatefulWidget {
  @override
  _GoogleAndFacebookSignInState createState() =>
      _GoogleAndFacebookSignInState();
}

class _GoogleAndFacebookSignInState extends State<GoogleAndFacebookSignIn> {
  bool googleLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;
  User currentUser;

  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("------------   ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w100)),
            Text("Or",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            Text("   ------------",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w100)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        SizedBox(height: hv * 2.1),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 27,
                backgroundColor: Color(0xff3b5998),
                child: Text(
                  "f",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            !googleLoading
                ? GestureDetector(
                    onTap: signInWithGoogle,
                    child: CircleAvatar(
                      radius: 27,
                      backgroundColor: Color(0xffde5246),
                      child: Icon(MdiIcons.google),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffde5246)),
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )),
          ],
        ),*/
      ],
    );
  }

  Future<Null> signInWithGoogle() async {
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    preferences = await SharedPreferences.getInstance();

    this.setState(() {
      googleLoading = true;
    });
    GoogleSignInAccount googleUser;
    try {
      googleUser = await googleSignIn.signIn();
    }
    catch (e){
      Fluttertoast.showToast(msg: "An unknown error occured", backgroundColor: Colors.red.withOpacity(0.7));
    }
    this.setState(() {
      googleLoading = false;
    });
    GoogleSignInAuthentication googleAuthentication =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken);

    User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      //Success

      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("Users")
          .where("id", isEqualTo: firebaseUser.uid)
          .get();

      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      if (documentSnapshots.length == 0) {
        FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser.uid)
          .set({
            "username": firebaseUser.displayName,
            "avatarUrl": firebaseUser.photoURL,
            "email": firebaseUser.email,
            "id": firebaseUser.uid,
            "aboutMe": "Just some guy",
            "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
            "chattingWith": null,
            "keyWords": getKeyWords(firebaseUser.displayName)
           });

        //write to local
        currentUser = firebaseUser;
                    
        userProfileProvider.setName(currentUser.displayName);
        userProfileProvider.setEmail(currentUser.email);
        userProfileProvider.setId(currentUser.uid);
        userProfileProvider.setAvatarUrl(currentUser.photoURL);
        userProfileProvider.setAboutMe("New User");
        userProfileProvider.setIsStaff(false);

        await preferences.setString("id", currentUser.uid);
        await preferences.setString("name", currentUser.displayName);
        await preferences.setString("email", currentUser.email);
        await preferences.setString("avatarUrl", currentUser.photoURL);
        await preferences.setString("aboutMe", "New User");
        await preferences.setBool("signedIn", true);
        print("Yooooooooooooooooo" + currentUser.uid);
      } else {
        //write to local
        currentUser = firebaseUser;
        await preferences.setString("id", documentSnapshots[0].data()["id"]);
        await preferences.setString(
            "name", documentSnapshots[0].data()["username"]);
        await preferences.setString(
            "email", documentSnapshots[0].data()["email"]);
        await preferences.setString(
            "avatarUrl", documentSnapshots[0].data()["avatarUrl"]);
        await preferences.setString(
            "aboutMe", documentSnapshots[0].data()["aboutMe"]);
        await preferences.setBool("signedIn", true);
      }

      Fluttertoast.showToast(msg: "Sign In Successful");
      this.setState(() {
        googleLoading = false;
      });

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      //fail
      Fluttertoast.showToast(msg: "Try again, Sign in Failed");
      this.setState(() {
        googleLoading = false;
      });
    }
  }

  List getKeyWords(String input) {
    List getKeys(String input) {
      var keyWords = new List(input.length);
      for (int i = 0; i < input.length; i++) {
        keyWords[i] = input.substring(0, i + 1).toLowerCase();
      }
      return keyWords;
    }

    List getKeysReversed(String input) {
      var keyWords = new List(input.length);
      for (int i = 0; i < input.length; i++) {
        keyWords[i] =
            input.substring(0, i + 1).toLowerCase().split('').reversed.join('');
      }
      return keyWords;
    }

    var results = [];
    String inputReversed = input.split('').reversed.join('');
    var words = input.toLowerCase().split(new RegExp('\\s+'));
    var wordsReversed = inputReversed.toLowerCase().split(new RegExp('\\s+'));

    for (int i = 0; i < words.length; i++) {
      results = results + getKeys(words[i]);
    }
    for (int i = 0; i < words.length; i++) {
      results = results + getKeysReversed(wordsReversed[i]);
    }

    results = results + getKeys(input);
    results = results.toSet().toList();

    return results;
  }
}
