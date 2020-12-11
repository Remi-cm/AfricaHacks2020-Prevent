import 'package:Prevent/views/map.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Prevent/helpers/guest.dart';
import 'package:Prevent/providers/guestStatusProvider.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:Prevent/views/account.dart';
import 'package:Prevent/views/chatRoom.dart';
import 'package:Prevent/views/search.dart';
import 'package:Prevent/views/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences preferences;
  String userId = "";
  String userName = "";
  String userEmail = "";
  String aboutMe = "";
  String avatarUrl = "";
  int _currentIndex = 0;
  List _pages = [MapPage(), ChatRoom()];

  _changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void getUserData() async {
    preferences = await SharedPreferences.getInstance();
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    String id = preferences.getString("id");
    String name = preferences.getString("name");
    String avatar = preferences.getString("avatarUrl");
    String email = preferences.getString("email");
    String about = preferences.getString("aboutMe");

    setState(() {
      userName = name;
      userId = id;
      avatarUrl = avatar;
      userEmail = email;
      aboutMe = about;
    });

    userProfileProvider.setId(id);
    userProfileProvider.setName(name);
    userProfileProvider.setAvatarUrl(avatar);
    userProfileProvider.setEmail(email);
    userProfileProvider.setAboutMe(about);
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Null> logoutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool googleSignInState = await googleSignIn.isSignedIn();
    FirebaseAuth.instance.currentUser;

    if (googleSignInState) {
      await googleSignIn.disconnect();
      await googleSignIn.signOut().catchError((err) {
        print(err.toString());
      });
      Navigator.pushNamedAndRemoveUntil(
          context, '/signIn', (Route<dynamic> route) => false);
      await preferences.clear();
    } else if (auth.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      await preferences.clear();
      Navigator.pushNamedAndRemoveUntil(
          context, '/signIn', (Route<dynamic> route) => false);
    }
    /*await FirebaseAuth.instance.signOut();
    

    Navigator.pushNamedAndRemoveUntil(
        context, '/signIn', (Route<dynamic> route) => false);*/
  }

  void changeTheme(BuildContext context) async {
    var themeProvider = Provider.of<ThemeModel>(context, listen: false);
    themeProvider.toggleMode();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("isDark", themeProvider.isDark);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context);
    GuestStatusProvider guestProvider = Provider.of<GuestStatusProvider>(context);
    final themeProvider = Provider.of<ThemeModel>(context);
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/pisaLogo.jpg'),
              radius: 17,
            ),
            SizedBox(
              width: 10,
            ),
            Text("PISA Mobile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,
              color: themeProvider.mode == ThemeMode.light ? Colors.black54 : Colors.white),),
          ],
        ),
        actions: <Widget>[
          /*IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: logoutUser,
          ),*/
          IconButton(
            icon: Icon(MdiIcons.accountBoxOutline),
            onPressed: () {
              !guestProvider.isGuest ? Navigator.pushNamed(context, '/account') : GuestOperations().askSignIn(context);
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            children: <Widget>[
              !guestProvider.isGuest ? Container(
                  padding: EdgeInsets.all(wv * 5),
                  //decoration: BoxDecoration(color: Theme.of(context).backgroundColor,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: (avatarUrl != null) || (userProfileProvider.getAvatar != null)
                            ? CachedNetworkImageProvider(userProfileProvider.getAvatar != null ? userProfileProvider.getAvatar : avatarUrl)
                            : AssetImage("assets/images/avatar.png"),
                        backgroundColor: Colors.black54,
                        radius: wv * 7,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        userProfileProvider.getName != null ? userProfileProvider.getName : userName,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(userProfileProvider.getEmail != null ? userProfileProvider.getEmail : userEmail)
                    ],
                  )) :
                  Container(
                  padding: EdgeInsets.all(wv * 5),
                  //decoration: BoxDecoration(color: Theme.of(context).backgroundColor,),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/images/avatar.png"),
                            backgroundColor: Colors.black54,
                            radius: wv * 7,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Guest User",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("You are not yet signed in")
                        ],
                      ),
                      RaisedButton(
                            child: Text("Sign In", style: TextStyle(color: Colors.white),),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            onPressed: (){
                              Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
                            }
                      )
                    ],
                  ))
                  ,
              Divider(
                thickness: 1,
                height: 0,
              ),
              DrawerItem(
                icon: MdiIcons.moonFull,
                title: themeProvider.mode == ThemeMode.light
                    ? "Dark Mode"
                    : "Light Mode",
                action: () => changeTheme(context),
              ),
              Divider(height: 0),
              !guestProvider.isGuest ? Column(
                children: <Widget>[
                  
                  DrawerItem(
                    icon: MdiIcons.accountBoxOutline,
                    title: "Profile",
                    action: () {
                      Navigator.pushNamed(context, '/account');},
                  ),
                  Divider(height: 0),
                  DrawerItem(
                    icon: MdiIcons.chatOutline,
                    title: "Messages",
                    action: () {
                          setState(() {
                            _currentIndex = 1;
                          });
                    },
                  ),
                  Divider(height: 0),
                  /*DrawerItem(
                    icon: MdiIcons.shareAllOutline,
                    title: "Tell a friend",
                    action: () {},
                  ),
                  Divider(height: 0),
                  DrawerItem(
                    icon: MdiIcons.starOutline,
                    title: "Rate us",
                    action: () {
                      Navigator.pushNamed(context, '/splashScreen');
                    },
                  ),
                  Divider(height: 0),
                  DrawerItem(
                    icon: MdiIcons.informationOutline,
                    title: "Help and Feedback",
                    action: () {},
                  ),
                  Divider(height: 0),*/
                  DrawerItem(
                    icon: MdiIcons.logout,
                    title: "Sign Out",
                    action: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return LogOutDialogBox(
                            content: "Your appointment was successfully registered. We'll get back to you very soon for more details",
                            action: () {logoutUser();},
                          );
                        });
                    },
                  ),
                  Divider(height: 0),
                ],
              ) : Container(),
              
            ],
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: _currentIndex,
          onTap: _changeIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.hammerScrewdriver),
                title: Text("Services")),
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.chat), title: Text("Conversations")),
          ]),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function action;

  const DrawerItem({Key key, this.icon, this.title, this.action})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: action,
    );
  }
}

class LogOutDialogBox extends StatelessWidget {
  final String content;
  final UserProfileProvider user;
  final Function action;

  const LogOutDialogBox(
      {Key key, this.content, this.user, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: replyContentBox(context),
    );
  }

  replyContentBox(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    double avatarRadius = wv*8;
    double padding = wv*5;
    return Padding(
      padding: const EdgeInsets.only(bottom: 200.0),
      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(minWidth: 300),
            padding: EdgeInsets.only(
                left: padding,
                top: avatarRadius + padding/2,
                right: padding,
                bottom: padding/2),
            margin: EdgeInsets.only(top: avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: new Offset(3.0, 3.0),
                      blurRadius: 2,
                      spreadRadius: 2),
                ],),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Are you sure you want to sign out?",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 22,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(onPressed: action,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color:  Colors.red, 
                      child: Text("Confirm", style: TextStyle(color: Colors.white),)),

                    SizedBox(width: 10,),
                      
                    FlatButton(onPressed: (){
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color:  Theme.of(context).primaryColor, 
                      child: Text("Cancel", style: TextStyle(color: Colors.white),)),
                  ],
                ),
              ],
            ),
          ), // bottom part
          Positioned(
            left: padding,
            right: padding,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Icon(MdiIcons.logout, size: wv*8, color: Colors.white,),
              ),
            ),
          ) // top part
        ],
      ),
    );
  }
}