import 'dart:async';

import 'package:Prevent/providers/themeProvider.dart';
import 'package:Prevent/services/localStorage.dart';
import 'package:Prevent/views/home.dart';
import 'package:Prevent/views/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loggedIn;
  bool _loggedInStateExists;
  bool googleSignInState;

  Future<Map> getLoggedInState() async {
    bool state;
    await Future.delayed(Duration(seconds: 1));
    bool isDark = await LocalStorage.getTheme();
    await LocalStorage.getUserLoggedInState().then((value) {
      state = value;
      /*setState(() {
        _loggedIn = value;
      });*/
      print("$value");
    });
    return {
      "state" : state,
      "isDark" : isDark,
    };
  }

  checkLoggedInStateExistence() async {
    bool val = await LocalStorage.checkLoggedInStateExistence();
    setState(() {
      _loggedInStateExists = val;
    });
  }

  void isSignedIn() async {
    /*bool googleSignInState = await GoogleSignIn().isSignedIn();
    var loggedUser = FirebaseAuth.instance.currentUser;

    if (googleSignInState || (loggedUser != null)) {
      setState(() {
        googleSignInState = true;
      });
      Navigator.pushNamed(context, '/chatRoom');
      print("${ModalRoute.of(context).settings.name}");
    }*/
  }

  /*void setTheme(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    themeProvider.setPhoneTheme();
  }*/

  @override
  void initState() {
    //isSignedIn();
    //checkLoggedInStateExistence();
    getLoggedInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context, listen: false);
    /*Timer(Duration(seconds: 3), () async {
      bool googleSignInState = await GoogleSignIn().isSignedIn();
      bool _signedIn = await LocalStorage.getUserLoggedInState();
      if (true) {
        print("dedans");
        _signedIn
            ? Navigator.pushNamed(context, '/home')
            : Navigator.pushNamed(context, '/signIn');
      }
    });*/
    return FutureBuilder(
        future: getLoggedInState(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if ((themeProvider.mode == ThemeMode.light) && (snapshot.data["isDark"])) {
              //themeProvider.toggleMode();
            }
            if (snapshot.data["state"] == true) {
              return Home();
            } else {
              return SignIn();
            }
          } else {
            print("yo");
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(height: 100),
                        CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/pisaLogo.jpg"),
                          radius: 55,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "We all deserve Comfort",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        ),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        });
    /*Scaffold(
      body: Center(child: Text("Splash screeeeen !!")),
    );*/
  }
}
