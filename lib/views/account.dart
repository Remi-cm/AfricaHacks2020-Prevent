import 'package:Prevent/helpers/algorithms.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:Prevent/theming/theme.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'components/formTools.dart';
import 'components/settingsFormTools.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final accountSettingsFormKey = GlobalKey<FormState>();
  SharedPreferences preferences;
  String userId = "";
  String userName = "";
  String userEmail = "";
  String aboutMe = "";
  String avatarUrl = "";
  TextEditingController nameController;
  TextEditingController aboutController;
  TextEditingController emailController;
  File imageFileAvatar;
  bool imageLoading = false;
  bool saveLoading = false;
  bool autoValidate = false;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  void getUserData() async {
    preferences = await SharedPreferences.getInstance();
    String id = preferences.getString("id");
    String name = preferences.getString("name");
    String avatar = preferences.getString("avatarUrl");
    String email = preferences.getString("email");
    String about = preferences.getString("aboutMe");
    nameController = TextEditingController(text: name);
    aboutController = TextEditingController(text: about);
    emailController = TextEditingController(text: email);

    setState(() {
      userName = name;
      userId = id;
      avatarUrl = avatar;
      userEmail = email;
    });
  }

  Future getImageFromGallery(BuildContext context) async {
    File newImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImageFile != null) {
      setState(() {
        this.imageFileAvatar = newImageFile;
        imageLoading = true;
      });
    }

    uploadImageToFirebase(context);
  }

  Future getImageFromCamera(BuildContext context) async {
    File newImageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (newImageFile != null) {
      setState(() {
        this.imageFileAvatar = newImageFile;
        imageLoading = true;
      });
    }

    uploadImageToFirebase(context);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    setState(() {
      imageLoading = true;
    });
    String fileName = userId;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask storageUploadTask =
        storageReference.putFile(imageFileAvatar);
    StorageTaskSnapshot storageTaskSnapshot;
    storageUploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((newAvatarUrl) {
          avatarUrl = newAvatarUrl;
          FirebaseFirestore.instance
              .collection("Users")
              .doc(userId)
              .update({"avatarUrl": avatarUrl}).then((data) async {
            await preferences.setString("avatarUrl", avatarUrl);
            userProfileProvider.setAvatarUrl(avatarUrl);
            setState(() {
              imageLoading = false;
            });
            Fluttertoast.showToast(msg: "Update successful");
          });
        }, onError: (errorMsg) {
          setState(() {
            imageLoading = false;
          });
          Fluttertoast.showToast(msg: "Error occured in getting Download url.");
        });
      }
    }, onError: (errorMsg) {
      setState(() {
        imageLoading = false;
      });
      Fluttertoast.showToast(msg: errorMsg.toString());
    });
  }

  void updateData() {}

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context);
    final themeProvider = Provider.of<ThemeModel>(context);
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      backgroundColor: themeProvider.mode == ThemeMode.light ? Colors.grey[100] : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: themeProvider.mode == ThemeMode.light ? Colors.grey[100] : Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: 0,
        leading: InkWell(
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
        title: Text(
          "Profile Settings",
          style: TextStyle(color: themeProvider.mode == ThemeMode.light ? Colors.grey[700] : Colors.grey[100]),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
           // SizedBox(height: hv * 3),
            Stack(
              children: <Widget>[
                //Body
                Container(
                  margin:
                      EdgeInsets.only(left: wv * 4, right: wv * 4, top: hv * 9),
                  padding: EdgeInsets.all(wv * 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black45.withOpacity(0.1),
                          offset: new Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          spreadRadius: 1.0),
                    ],
                  ),
                  child: Form(
                    key: accountSettingsFormKey,
                    autovalidate: autoValidate,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: hv * 10),
                        CustomSettingsTextField(
                            labelText: "User Name",
                            hintText: "User Pseudo",
                            icon: Icons.account_circle,
                            emptyValidatorText: 'Enter Name',
                            validator: _nameFieldValidator,
                            controller: nameController,
                            focusNode: nameFocusNode),
                        SizedBox(
                          height: hv * 2,
                        ),
                        CustomSettingsTextField(
                            labelText: "Email",
                            hintText: "Email",
                            icon: Icons.mail,
                            emptyValidatorText: 'Enter email address',
                            validator: _emailFieldValidator,
                            controller: emailController,
                            focusNode: emailFocusNode),
                        SizedBox(
                          height: hv * 2,
                        ),
                        CustomTextAreaField(
                          labelText: "About Me",
                          minLines: 1,
                          maxLines: 4,
                          hintText: "About Me",
                          icon: Icons.chat_bubble,
                          emptyValidatorText: 'Enter Name',
                          keyboardType: TextInputType.multiline,
                          validator: _aboutFieldValidator,
                          controller: aboutController,
                          focusNode: aboutMeFocusNode,
                        ),
                        SizedBox(
                          height: hv * 7,
                        ),
                        !saveLoading
                            ? CustomSettingsButton(
                                onPressed: (){updateProfile(context);},
                                color: Theme.of(context).primaryColor,
                                text: "Update",
                                textColor: Colors.white)
                            : Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor),
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )),
                        SizedBox(
                          height: hv * 0.5,
                        ),
                      ],
                    ),
                  ),
                ),

                //profile Image
                Container(
                  decoration: BoxDecoration(),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        (imageFileAvatar == null)
                            ? (avatarUrl != "")
                                ? Material(
                                    //Displaying already existing image
                                    child: avatarUrl != null ? CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor),
                                        ),
                                        width: wv * 30,
                                        height: wv * 30,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: avatarUrl,
                                      width: wv * 30,
                                      height: wv * 30,
                                      fit: BoxFit.cover,
                                    ) : Image.asset("assets/images/avatar.png",width: wv * 30,height: wv * 30,),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(125.0)),
                                    clipBehavior: Clip.hardEdge,
                                  )
                                : Icon(Icons.account_circle,
                                    size: 90.0, color: Colors.grey)
                            : !imageLoading
                                ? Material(
                                    //Displaying new image
                                    child: Image.file(
                                      imageFileAvatar,
                                      width: wv * 30,
                                      height: wv * 30,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(125),
                                    clipBehavior: Clip.hardEdge,
                                  )
                                : Material(
                                    //Displaying already existing image
                                    child: avatarUrl != null ? CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor),
                                        ),
                                        width: wv * 30,
                                        height: wv * 30,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: avatarUrl,
                                      width: wv * 30,
                                      height: wv * 30,
                                      fit: BoxFit.cover,
                                    ) : Image.asset("assets/images/avatar.png",width: wv * 30,height: wv * 30,),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(125.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: wv * 15,
                            color: Colors.white54.withOpacity(0.3),
                          ),
                          onPressed: () {
                            getImage(context);
                          },
                          padding: EdgeInsets.all(0.0),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.grey,
                          iconSize: wv * 30,
                        )
                      ],
                    ),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.all(hv * 2),
                ),
              ],
            ),
            SizedBox(
              height: hv * 5,
            )
          ],
        ),
      ),
    );
  }

  void getImage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImageFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageFromCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void updateProfile(BuildContext context) {
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    nameFocusNode.unfocus();
    emailFocusNode.unfocus();
    aboutMeFocusNode.unfocus();
    if (accountSettingsFormKey.currentState.validate()) {
      setState(() {
        saveLoading = true;
      });

      FirebaseFirestore.instance.collection("Users").doc(userId).update({
        "username": nameController.text,
        "email": emailController.text,
        "aboutMe": aboutController.text,
        "keyWords": Algorithms().getKeyWords(nameController.text)
      }).then((data) async {
        await preferences.setString("name", nameController.text);
        await preferences.setString("email", emailController.text);
        await preferences.setString("aboutMe", aboutController.text);

        userProfileProvider.setName(nameController.text);
        userProfileProvider.setEmail(emailController.text);
        userProfileProvider.setAboutMe(aboutController.text);

        setState(() {
          saveLoading = false;
        });
        Fluttertoast.showToast(msg: "Update successful");
      });
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

  String _aboutFieldValidator(String value) {
    if (value.isEmpty) {
      return "About Me must not be empty";
    }
  }
}
