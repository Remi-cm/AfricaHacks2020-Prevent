import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/helpers/algorithms.dart';
import 'package:Prevent/providers/guestStatusProvider.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:Prevent/services/auth.dart';
import 'package:Prevent/services/database.dart';
import 'package:Prevent/services/localStorage.dart';
import 'package:Prevent/theming/colors.dart';
import 'package:Prevent/views/components/appBar.dart';
import 'package:Prevent/views/components/formTools.dart';
import 'package:Prevent/views/components/logoAndSlogan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/googleFacebookSignIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpFormKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  LocalStorage localStorage = new LocalStorage();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool _autovalidate = false;
  bool _buttonState = true;
  bool _autoValidate = false;
  SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: hv * 5),
              LogoAndSlogan(),
              SizedBox(height: hv * 8),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _signUpFormKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        CustomTextField(
                          hintText: "Userame",
                          icon: Icons.account_circle,
                          emptyValidatorText: 'Enter Name',
                          validator: _nameFieldValidator,
                          controller: _nameController,
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Email",
                          icon: Icons.mail,
                          emptyValidatorText: 'Enter email address',
                          validator: _emailFieldValidator,
                          controller: _emailController,
                        ),
                        SizedBox(height: 10),
                        CustomPasswordTextField(
                            hintText: "Password",
                            icon: Icons.lock,
                            validator: _passwordFieldValidator,
                            emptyValidatorText: 'Enter password',
                            controller: _passwordController),
                        SizedBox(height: 30),
                        _buttonState
                            ? AnimatedOpacity(
                                opacity: _buttonState ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 1500),
                                child: CustomButton(
                                    onPressed: _signUp,
                                    text: "Sign Up",
                                    textColor: Colors.white,
                                    color: Theme.of(context).primaryColor))
                            : Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor),
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )),
                        SizedBox(height: hv * 2.1),
                        //GoogleAndFacebookSignIn(),
                        SizedBox(height: hv * 2.1),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        margin: EdgeInsets.symmetric(vertical: hv * 3),
        child: Row(
          children: <Widget>[
            Text("Already have an account?  ",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            InkWell(
              child: Text("Sign In",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pushNamed(context, '/signIn');
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      )),
    );
  }

// SignUp function

  _signUp() async {
    GuestStatusProvider guestProvider = Provider.of<GuestStatusProvider>(context, listen: false);
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    preferences = await SharedPreferences.getInstance();
    if (_signUpFormKey.currentState.validate()) {
      setState(() {
        _buttonState = false;
      });
      Map<String, String> user = {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text
      };
      try {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: user["email"], password: user["password"])
            .catchError((e) {
              print('Failed with error code: ${e.code}');
              print(e.message);
              setState(() {
                _buttonState = true;
              });
              print(e.toString());
              Fluttertoast.showToast(
                msg:
                    'An unexpected error occured,\ntry checking your internet connection\nor changing the email address',
                backgroundColor: Colors.red,
                textColor: white,
              );
              if (e.code == 'weak-password') {
                Fluttertoast.showToast(
                  msg: 'The password provided is too weak.',
                  backgroundColor: Colors.red,
                  textColor: white,
                );
              } else if (e.code == 'email-already-in-use') {
                Fluttertoast.showToast(
                  msg: 'The account already exists for that email.',
                  backgroundColor: Colors.white,
                  textColor: white,
                );
              } else if (e.code == 'invalid-email') {
                Fluttertoast.showToast(
                  msg: 'The email address is badly formatted.',
                  backgroundColor: Colors.white,
                  textColor: white,
                );
              }
        }).then((currentUser) async {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser.user.uid)
              .set({
            "username": user["name"],
            "avatarUrl": null,
            "email": user["email"],
            "id": currentUser.user.uid,
            "aboutMe": "Hey, I'm new here.",
            "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
            "chattingWith": null,
            "isStaff": false,
            "skillSet": [],
            "title": "Normal User",
            "phone": null,
            "keyWords": Algorithms().getKeyWords(user["name"])
          });
          Fluttertoast.showToast(
            msg: "User " + user["name"] + " Registered successfully",
            backgroundColor: Color(0xFF605BBD),
            textColor: white,
          );
          
          guestProvider.setStatus(false);
          //var data = await DatabaseMethods().getUserById(currentUser.user.uid);
          userProfileProvider.setId(currentUser.user.uid);
          userProfileProvider.setName(user["name"]);
          userProfileProvider.setEmail(user["email"]);
          userProfileProvider.setAboutMe("Hey, I'm new here.");
          userProfileProvider.setIsStaff(false);

          await preferences.setString("id", currentUser.user.uid);
          await preferences.setString("name", user["name"]);
          await preferences.setString("email", user["email"]);
          await preferences.setString("avatarUrl", null);
          await preferences.setBool("isStaff", false);
          await preferences.setString("aboutMe", "Hey, I'm new here.");
          await preferences.setBool("signedIn", true);
          setState(() {
            _buttonState = true;
          });
          Navigator.pushReplacementNamed(context, "/home");
          //return currentUser.user;
        }); //.then((res) {});
      } on FirebaseAuthException catch (e) {
        setState(() {
          _buttonState = true;
        });
        print('Failed with error code: ${e.code}');
        print(e.message);
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
            msg: 'The password provided is too weak.',
            backgroundColor: Colors.red,
            textColor: white,
          );
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'The account already exists for that email.',
            backgroundColor: Colors.white,
            textColor: white,
          );
        } else if (e.code == 'invalid-email') {
          Fluttertoast.showToast(
            msg: 'The email address is badly formatted.',
            backgroundColor: Colors.white,
            textColor: white,
          );
        }
      } catch (e) {
        setState(() {
          _buttonState = true;
        });
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
            msg: 'The password provided is too weak.',
            backgroundColor: Colors.red,
            textColor: white,
          );
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'The account already exists for that email.',
            backgroundColor: Colors.white,
            textColor: white,
          );
        } else if (e.code == 'invalid-email') {
          Fluttertoast.showToast(
            msg: 'The email address is badly formatted.',
            backgroundColor: Colors.white,
            textColor: white,
          );
        }
        print(e.toString());
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: white,
        );
      }
      /*User firebaseUser = await AuthMethods().signUpwithEmailAndPassword(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          context);

      if (firebaseUser != null) {
        var data = DatabaseMethods().getUserById(firebaseUser.uid);
        await preferences.setString("id", firebaseUser.uid);
        await preferences.setString("name", _nameController.text);
        await preferences.setString("email", _emailController.text);
        await preferences.setString("avatarUrl", data["avatarUrl"]);
        await preferences.setString("aboutMe", data["aboutMe"]);
        setState(() {
          _buttonState = true;
        });
        Navigator.pushReplacementNamed(context, "/chatRoom");
      } else {
        print("le ndem");
        setState(() {
          _buttonState = true;
        });
      }*/
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  // TextFields validator functions

  String _passwordFieldValidator(String value) {
    if (value.length < 6) {
      return "Password must be greater than 5";
    }
  }

  String _emailFieldValidator(String value) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Provide a valid email";
    }
  }

  String _nameFieldValidator(String value) {
    if (value.isEmpty || value.length < 4) {
      return "Username must be greater than 4";
    }
  }
}
