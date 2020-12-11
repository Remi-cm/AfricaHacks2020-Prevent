import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Prevent/helpers/guest.dart';
import 'package:Prevent/models/chatRoom.dart';
import 'package:Prevent/models/user.dart';
import 'package:Prevent/providers/guestStatusProvider.dart';
import 'package:Prevent/providers/productProvider.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:Prevent/providers/userBudgetProvider.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:Prevent/views/components/formTools.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/serviceCard.dart';
import 'components/staffTile.dart';

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  SharedPreferences preferences;
  String userId = "";
  String userName = "";
  String userEmail = "";
  String aboutMe = "";
  String avatarUrl;
  CarouselController buttonCarouselController = CarouselController();
  TextEditingController budgetDialogInputController = new TextEditingController();
  bool dialogButtonEnabled = false;

  void getUserData() async {
    preferences = await SharedPreferences.getInstance();
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
  }

  consultantsList() {
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context);
    GuestStatusProvider guestProvider = Provider.of<GuestStatusProvider>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .where("isStaff", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data.documents.length >= 1 ? ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot user = snapshot.data.documents[index];
            AppUser singleUser = AppUser.fromDocument(user);
            if (singleUser.id == userId) {
              return Container();
            }
            ChatRoomModel chatRoomData = ChatRoomModel(lastMessageFrom: userId);
            Map<String, dynamic> chatRoom = {
              "targetId": singleUser.id,
              "targetAvatar": singleUser.avatarUrl,
              "localAvatar" : userProfileProvider.getAvatar != null ? userProfileProvider.getAvatar : avatarUrl,
              "targetName": singleUser.name,
              "userId": userProfileProvider.getId != null ? userProfileProvider.getId : userId,
              "chatRoomData": chatRoomData
            };
            
            return StaffTile(
              avatarUrl: singleUser.avatarUrl,
              name: singleUser.name,
              title: singleUser.title,
              email: singleUser.email,
              action: (){!guestProvider.isGuest ? Navigator.pushNamed(context, '/conversation', arguments: chatRoom) : GuestOperations().askSignIn(context);},
            );
          },
        ) :
        Container();
      },
    );
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
    ProductProvider prodProvider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeModel>(context);
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    EdgeInsets margin = EdgeInsets.symmetric(horizontal: wv*2);
    return Scaffold(
      backgroundColor: themeProvider.mode == ThemeMode.light
          ? Color(0xfffdfbff)
          : Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CarouselSlider(
                      carouselController: buttonCarouselController,
                      options: CarouselOptions(
                        pauseAutoPlayOnManualNavigate: true,
                        height: hv*30,
                        aspectRatio: 16/9,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: [
                        carouselItem(imgPath: 'assets/images/pisaHouse1.jpg', label: ''),
                        carouselItem(imgPath: 'assets/images/pisaHouse2.jpg', label: ''),
                        carouselItem(imgPath: 'assets/images/pisaHouse3.jpg', label: ''),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: wv*2),
                      height: hv*30,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            child: IconButton(icon: Icon(Icons.arrow_back_ios), color: Colors.grey[200], onPressed: (){buttonCarouselController.previousPage();}), 
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                          ),
                          CircleAvatar(
                            child: IconButton(icon: Icon(Icons.arrow_forward_ios), color: Colors.white, onPressed: (){buttonCarouselController.nextPage();}), 
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                          ),
                      ],),
                    ),
                  ],
                ),
                SizedBox(height: hv*2,),
                !guestProvider.isGuest ? Padding(
                  padding: margin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxWidth: wv*70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Hello,",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight
                                      .w800, /*Theme.of(context).primaryColor*/
                                )),
                            Text(
                              userProfileProvider.getName != null ? userProfileProvider.getName : userName,
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: themeProvider.mode == ThemeMode.light
                                      ? Colors.brown[700]
                                      : Colors.white),
                                      overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: (avatarUrl != null) || (userProfileProvider.getAvatar != null)
                                  ? CachedNetworkImageProvider(userProfileProvider.getAvatar != null ? userProfileProvider.getAvatar : avatarUrl)
                                  : AssetImage("assets/images/avatar.png"),
                            )),
                      )
                    ],
                  ),
                )
                : Container(),
                SizedBox(height: hv * 2),
                Padding(
                  padding: margin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ServiceCard(
                        title: "Your Budget",
                        subtitle: "What do you have?",
                        icon: MdiIcons.creditCard,
                        themeColor: Colors.white,
                        subtitleColor: Colors.deepPurple[500],
                        bgColor: Theme.of(context).primaryColor.withOpacity(0.7),
                        action: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ReplyDialogBox(
                                  name: "Input your Budget",
                                  content:"ex: 8,500,000 XAF",
                                  user: Provider.of<UserProfileProvider>(context),
                                  inputController: budgetDialogInputController,
                                  fromService: true,
                                );
                              });
                        },
                      ),
                      ServiceCard(
                        title: "Your Need",
                        subtitle: "What do you need?",
                        icon: MdiIcons.headDotsHorizontalOutline,
                        subtitleColor: Colors.grey[500],
                        themeColor: Colors.grey[700],
                        bgColor: Theme.of(context).cardColor,
                        action: () {!guestProvider.isGuest ? Navigator.pushNamed(context, '/need') : GuestOperations().askSignIn(context);},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: margin,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: hv * 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(wv*7),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: themeProvider.mode == ThemeMode.light
                                      ? Colors.grey[400].withOpacity(0.2)
                                      : Colors.white.withOpacity(0),
                                  offset: new Offset(1.0, 1.0),
                                  blurRadius: 4,
                                  spreadRadius: 1),
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: wv * 60,
                              padding: EdgeInsets.symmetric(
                                  horizontal: wv * 5, vertical: wv * 5),
                              child: Column(children: <Widget>[
                                Text(
                                  "Stay updated about our latest advancements by following us on our different social platforms",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          themeProvider.mode == ThemeMode.light
                                              ? Colors.grey[900]
                                              : Colors.white),
                                ),
                                SizedBox(height: hv * 1.5),
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap:  (){},
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xff3b5998),
                                        child: Icon(MdiIcons.facebook,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: wv * 1.5),
                                    GestureDetector(
                                      onTap: (){},  /*async {
                                        const url = 'https://www.instagram.com/invites/contact/?i=70cclxjz5jel&utm_content=j3ds9z5';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }},*/
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xffdd2a7b),
                                        child: Icon(MdiIcons.instagram,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: wv * 1.5),
                                    GestureDetector(
                                      onTap:  (){},
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xff00acee),
                                        child: Icon(MdiIcons.twitter,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          top: hv * 5,
                          right: 0,
                          child: Container(
                              width: wv * 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Image.asset(
                                'assets/images/socials.png',
                                fit: BoxFit.contain,
                              )))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: wv * 3, right: wv * 3),
                  child: Text("Our top advisors"),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: hv * 1),
                  height: hv * 20,
                  child: consultantsList(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: wv * 3, right: wv * 3, top: hv * 3, bottom: hv * 3),
                  child: ButtonTheme(
                    padding: EdgeInsets.symmetric(vertical: hv * 2),
                    minWidth: double.infinity,
                    child: FlatButton(
                        onPressed: () {
                          prodProvider.setId("consulting");
                          !guestProvider.isGuest ? Navigator.pushNamed(context, '/appointment') : GuestOperations().askSignIn(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Make Appointment",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: hv * 2.3,
                              fontWeight: FontWeight.w900),
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  carouselItem ({String imgPath, String label}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.fill),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Colors.white),),
        ],
      )
    );
  }
}

class ReplyDialogBox extends StatefulWidget {
  final String name;
  final String content;
  final String contentType;
  final UserProfileProvider user;
  final TextEditingController inputController;
  final bool fromService;

  const ReplyDialogBox(
      {Key key, this.name, this.inputController, this.content, this.contentType, this.user, this.fromService})
      : super(key: key);

  @override
  _ReplyDialogBoxState createState() => _ReplyDialogBoxState();
}

class _ReplyDialogBoxState extends State<ReplyDialogBox> {
  bool enabled = false;
  @override
  void initState() { 
    
    if(widget.inputController.text != ""){
      setState(() {
        enabled = true;
      });
    }
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: replyContentBox(context)
        ),
    );
  }

  replyContentBox(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    double avatarRadius = wv*10;
    double padding = wv*6;
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
                  widget.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: hv*2,
                ),
                CustomPriceTextField(
                  hintText: widget.content,
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  controller: widget.inputController,
                  onChangedFunc: (val){
                    RegExp(r'\d').hasMatch(val) && RegExp(r'\d').hasMatch(widget.inputController.text) ?
                      setState(() {
                        enabled = true;
                      })
                      :
                      setState(() {
                        enabled = false;
                      });
                  },
                ),
                SizedBox(
                  height: hv*2,
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: enabled ? getProducts : null,
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Proceed",
                              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ), // bottom part
          Positioned(
            left: padding,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/pisaLogo.jpg'),
                  radius: avatarRadius*2.5/3,
                ),
              ),
            ),
          ) // top part
        ],
      ),
    );
  }

  getProducts () {
    UserBudgetProvider userBudgetProvider = Provider.of<UserBudgetProvider>(context, listen: false);
    userBudgetProvider.setBudget(int.parse(widget.inputController.text));
    Navigator.pop(context);
    widget.fromService ? Navigator.pushNamed(context, '/results') : Navigator.pushReplacementNamed(context, '/results');
  }
}