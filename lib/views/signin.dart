import 'package:Prevent/providers/guestStatusProvider.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:Prevent/services/auth.dart';
import 'package:Prevent/views/components/googleFacebookSignIn.dart';
import 'package:Prevent/views/components/logoAndSlogan.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Prevent/services/database.dart';
import 'package:Prevent/services/localStorage.dart';
import 'package:Prevent/views/components/formTools.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoggedIn = false;
  bool googleLoading = false;
  User currentUser;

  final _signInFormKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool _autovalidate = false;
  bool _buttonState = true;
  bool _autoValidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      isLoggedIn = true;
    });

    preferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    var loggedUser = await FirebaseAuth.instance.currentUser;

    if (isLoggedIn || (loggedUser != null)) {
      Navigator.pushNamed(context, '/chatRoom');
      print("${ModalRoute.of(context).settings.name}");
    }

    setState(() {
      googleLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    GuestStatusProvider guestProvider = Provider.of<GuestStatusProvider>(context);
    final themeProvider = Provider.of<ThemeModel>(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: hv * 5),
          LogoAndSlogan(),
          Column(
            children: <Widget>[
              SizedBox(height: hv * 8),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _signInFormKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        CustomTextField(
                          hintText: "Email",
                          icon: Icons.mail,
                          emptyValidatorText: 'Enter email address',
                          validator: _emailFieldValidator,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            CustomPasswordTextField(
                                hintText: "Password",
                                icon: Icons.lock,
                                validator: _passwordFieldValidator,
                                emptyValidatorText: 'Enter password',
                                controller: _passwordController),
                            SizedBox(height: 7),
                            Text("Not less than 6 characters  ",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),

                        SizedBox(height: hv * 3.6),

                        _buttonState
                            ? CustomButton(
                                onPressed: () async {await _signIn();},
                                text: "Sign In",
                                textColor: Colors.white,
                                color: Theme.of(context).primaryColor)
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

                        /*GoogleAndFacebookSignIn(),*/
                        _buttonState ?
                        Container(
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: themeProvider.mode == ThemeMode.light ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.0),
                                offset: new Offset(0.0, 0.0),
                                blurRadius: 2,
                                spreadRadius: 2),
                          ],
                          ),
                          child: CustomButton(
                            onPressed: () {
                              guestProvider.setStatus(true);
                              Navigator.pushNamed(context, '/home');
                            },
                            text: "Continue Without Sign In",
                            textColor: Theme.of(context).primaryColor,
                            color: Colors.white
                          ),
                        ) : Container(),

                        SizedBox(height: 15)

                        //Center(child: Text("Forgot Password ?", style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w800 )),)
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
            Text("Don't you have an account?  ",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            InkWell(
              child: Text("Sign Up Now",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pushNamed(context, '/signUp');
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      )),
    );
  }

  _signIn() async {
    GuestStatusProvider guestProvider = Provider.of<GuestStatusProvider>(context, listen: false);
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_signInFormKey.currentState.validate()) {
      setState(() {
        _buttonState = false;
      });
      print(_passwordController.text + " and " + _emailController.text);
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .catchError((e) {
              print('Failed with error code: ${e.code}');
              print(e.message);
              setState(() {
                _buttonState = true;
              });
              print(e.toString());
              
              if (e.code == 'user-not-found') {
                Fluttertoast.showToast(
                  msg: 'No user found for this email.',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              } else if (e.code == 'wrong-password') {
                Fluttertoast.showToast(
                  msg: 'The password provided for this account is incorrect.',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              } else if (e.code == 'invalid-email') {
                Fluttertoast.showToast(
                  msg: 'The email address is badly formatted.',
                  backgroundColor: Colors.white,
                  textColor: Colors.white,
                );
              }
              else {
                Fluttertoast.showToast(
                  msg:
                      'An unexpected error occured,\ntry checking your internet connection\nor changing the email address',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
        }).
          then((currentUser) => FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser.user.uid)
                  .get()
                  .then((DocumentSnapshot data) async {
                    guestProvider.setStatus(false);
                    
                    userProfileProvider.setName(data.data()["username"]);
                    userProfileProvider.setEmail(data.data()["username"]);
                    userProfileProvider.setId(currentUser.user.uid);
                    userProfileProvider.setAvatarUrl(data.data()["avatarUrl"]);
                    userProfileProvider.setAboutMe(data.data()["aboutMe"]);
                    data.data()["isStaff"] != null ? 
                      userProfileProvider.setIsStaff(data.data()["isStaff"])
                    : print("isStaff is null");

                    await preferences.setString("id", currentUser.user.uid);
                    await preferences.setString("name", data.data()["username"]);
                    await preferences.setString("email", _emailController.text);
                    await preferences.setString("avatarUrl", data.data()["avatarUrl"]);
                    await preferences.setString("aboutMe", data.data()["aboutMe"]);
                    await preferences.setBool("signedIn", true);
                    setState(() {
                      _buttonState = true;
                    });
                    Navigator.pushReplacementNamed(context, "/home");
              }))
          .catchError((err) {
            setState(() {
              _buttonState = true;
            });
            /*Fluttertoast.showToast(
              msg: err.toString(),
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );*/
          }).catchError((err) {
            setState(() {
              _buttonState = true;
          });
          /*Fluttertoast.showToast(
            msg: err.toString(),
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );*/
      });
      /*var user = await AuthMethods().signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      setState(() {
        _buttonState = true;
      });
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/chatRoom");
      } else {
        Fluttertoast.showToast(
          msg: 'Wrong credentials',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }*/

      //LocalStorage.saveUserName(_nameController.text);
      //LocalStorage.saveUserLEmail(_emailController.text);

      /*setState(() {
        _buttonState = false;
      });*/

      //Navigator.pushReplacementNamed(context, '/chatRoom');
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String _passwordFieldValidator(String value) {
    if (value.length < 6) {
      return "Password must be greater than 5";
    }
  }

  //Fonction de validation du numéro de téléphone

  String _emailFieldValidator(String value) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Provide a valid email";
    }
  }
}
