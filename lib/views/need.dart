import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/providers/needProvider.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:Prevent/views/components/roomCard.dart';
import 'package:Prevent/views/components/surfaceCard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class Need extends StatefulWidget {
  @override
  _NeedState createState() => _NeedState();
}

class _NeedState extends State<Need> {
  CarouselController buttonCarouselController = CarouselController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      body: SafeArea(
        child: CarouselSlider(
          carouselController: buttonCarouselController,
          options: CarouselOptions(
            scrollPhysics: BouncingScrollPhysics(),
            height: hv * 100,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
          items: [
            getRooms(context),
            getSurcace(context),
            getOffice(context),
            getSportsRoom(context)
          ],
        ),
      ),
    );
  }

  Widget getSurcace(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    final needProvider = Provider.of<NeedProvider>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.grey[500],), onPressed: (){buttonCarouselController.previousPage();}),
            ],
          ),
          SizedBox(height: hv*4),
          Text("Choose preferred Surface", style: TextStyle(fontSize: wv*5, fontWeight: FontWeight.bold),),
          SizedBox(height: hv*4,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SurfaceCard(
                action: (){
                  needProvider.setSurface(false);
                },
                icon: MdiIcons.viewGridOutline,
                title: "350M²-",
                subtitle: "Less than 350M²",
                bgColor: needProvider.getSurface ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                themeColor: needProvider.getSurface ? Colors.grey[700] : Colors.white,
                subtitleColor: needProvider.getSurface ? Colors.grey : Colors.white.withOpacity(0.7),
              ),
              SizedBox(width: wv*4,),
              SurfaceCard(
                action: (){
                  needProvider.setSurface(true);
                },
                icon: MdiIcons.viewGridOutline,
                title: "350M²+",
                subtitle: "More than 350M²",
                bgColor: needProvider.getSurface ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                themeColor: needProvider.getSurface ? Colors.white : Colors.grey[700],
                subtitleColor: needProvider.getSurface ? Colors.white.withOpacity(0.7) : Colors.grey,
              ),
            ],
          ),
          Container(
            height: hv*20,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: wv*15),
            child: Text(
              needProvider.getSurface ? 
              "Big house of more than 350M² for a larger family" : 
              "Standard house of less than 350M² for a small family",
              style: TextStyle(fontSize: wv*4),
              textAlign: TextAlign.center,),
          ),
          SizedBox(
            width: wv*84,
            child: RaisedButton(
              onPressed: (){buttonCarouselController.nextPage();},
              padding: EdgeInsets.symmetric(vertical: hv*1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Proceed", style: TextStyle(color: Colors.white, fontSize: wv*4, fontWeight: FontWeight.w700),),
                  SizedBox(width: 5,),
                  Icon(Icons.arrow_forward, color: Colors.white)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getRooms(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    final needProvider = Provider.of<NeedProvider>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.grey[500],), onPressed: (){Navigator.pop(context);}),
            ],
          ),
          SizedBox(height: hv*2,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoomCard(
                icon: MdiIcons.homeHeart,
                title: needProvider.getLivingRoom,
                subtitle: "Living Room",
                bgColor: Theme.of(context).cardColor,
                themeColor: Colors.grey[700],
                subtitleColor: Colors.grey,
                remove: (){if(needProvider.getLivingRoom > 1){ needProvider.setLivingRoom(needProvider.getLivingRoom - 1); }},
                add: (){if(needProvider.getLivingRoom < 8){ needProvider.setLivingRoom(needProvider.getLivingRoom + 1); }},
              ),
              SizedBox(width: wv*4,),
              RoomCard(
                icon: Icons.kitchen,
                title: needProvider.getKitchen,
                subtitle: "Kitchen",
                bgColor: Theme.of(context).cardColor,
                themeColor: Colors.grey[700],
                subtitleColor: Colors.grey,
                remove: (){if(needProvider.getKitchen > 1){ needProvider.setKitchen(needProvider.getKitchen - 1); }},
                add: (){if(needProvider.getKitchen < 8){ needProvider.setKitchen(needProvider.getKitchen + 1); }},
              ),
            ],
          ),

          SizedBox(height: wv*4,),
          
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoomCard(
                icon: MdiIcons.bedOutline,
                title: needProvider.getBedroom,
                subtitle: "Bedroom",
                bgColor: Theme.of(context).cardColor,
                themeColor: Colors.grey[700],
                subtitleColor: Colors.grey,
                remove: (){if(needProvider.getBedroom > 1){ needProvider.setBedroom(needProvider.getBedroom - 1); }},
                add: (){if(needProvider.getBedroom < 8){ needProvider.setBedroom(needProvider.getBedroom + 1); }},
              ),
              SizedBox(width: wv*4,),
              RoomCard(
                icon: MdiIcons.toilet,
                title: needProvider.getBathroom,
                subtitle: "Bathroom",
                bgColor: Theme.of(context).cardColor,
                themeColor: Colors.grey[700],
                subtitleColor: Colors.grey,
                remove: (){if(needProvider.getBathroom > 1){ needProvider.setBathroom(needProvider.getBathroom - 1); }},
                add: (){if(needProvider.getBathroom < 8){ needProvider.setBathroom(needProvider.getBathroom + 1); }},
              ),
            ],
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: wv*15),
              child: 
            Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Choose the rooms configuration that matches the most your need, you can choose a maximum of 8 rooms per category", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
              ],
            ),
            ),
          ),
          SizedBox(
            width: wv*84,
            child: RaisedButton(
              onPressed: (){buttonCarouselController.nextPage();},
              padding: EdgeInsets.symmetric(vertical: hv*1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Proceed", style: TextStyle(color: Colors.white, fontSize: wv*4, fontWeight: FontWeight.w700),),
                  SizedBox(width: 5,),
                  Icon(Icons.arrow_forward, color: Colors.white)
                ],
              ),
            ),
          ),
          
              SizedBox(height: wv*5,),
        ],
      ),
    );
  }

  Widget getOffice(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    final needProvider = Provider.of<NeedProvider>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.grey[500],), onPressed: (){buttonCarouselController.previousPage();}),
            ],
          ),
          SizedBox(height: hv*4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wv*15),
            child: Text("Would you like an office or a library?", style: TextStyle(fontSize: wv*5, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          ),
          SizedBox(height: hv*4,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SurfaceCard(
                action: (){
                  needProvider.setOfficeLibrary(true);
                },
                icon: MdiIcons.check,
                title: "YES",
                subtitle: "I would like one",
                bgColor: needProvider.getOfficeLibrary ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                themeColor: needProvider.getOfficeLibrary ? Colors.white : Colors.grey[700],
                subtitleColor: needProvider.getOfficeLibrary ? Colors.white.withOpacity(0.7) : Colors.grey,
              ),
              SizedBox(width: wv*4,),
              SurfaceCard(
                action: (){
                  needProvider.setOfficeLibrary(false);
                },
                icon: MdiIcons.close,
                title: "NO",
                subtitle: "Not necessary",
                bgColor: needProvider.getOfficeLibrary ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                themeColor: needProvider.getOfficeLibrary ? Colors.grey[700] : Colors.white,
                subtitleColor: needProvider.getOfficeLibrary ? Colors.grey : Colors.white.withOpacity(0.7),
              ),
            ],
          ),
          Container(
            height: hv*20,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: wv*15),
            child: Text(
              needProvider.getOfficeLibrary ? 
              "A space suited for an office or a library will be added to your request" : 
              "No extra space suited for an office or a library will be added to your request",
              style: TextStyle(fontSize: wv*4),
              textAlign: TextAlign.center,),
          ),
          SizedBox(
            width: wv*84,
            child: RaisedButton(
              onPressed: (){buttonCarouselController.nextPage();},
              padding: EdgeInsets.symmetric(vertical: hv*1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Proceed", style: TextStyle(color: Colors.white, fontSize: wv*4, fontWeight: FontWeight.w700),),
                  SizedBox(width: 5,),
                  Icon(Icons.arrow_forward, color: Colors.white)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getSportsRoom(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    final needProvider = Provider.of<NeedProvider>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.grey[500],), onPressed: (){buttonCarouselController.previousPage();}),
            ],
          ),
          SizedBox(height: hv*4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: wv*15),
            child: Text("Would you like a sports room?", style: TextStyle(fontSize: wv*5, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          ),
          SizedBox(height: hv*4,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SurfaceCard(
                action: (){
                  needProvider.setSportsRoom(true);
                },
                icon: MdiIcons.check,
                title: "YES",
                subtitle: "I would like one",
                bgColor: needProvider.getSportsRoom ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                themeColor: needProvider.getSportsRoom ? Colors.white : Colors.grey[700],
                subtitleColor: needProvider.getSportsRoom ? Colors.white.withOpacity(0.7) : Colors.grey,
              ),
              SizedBox(width: wv*4,),
              SurfaceCard(
                action: (){
                  needProvider.setSportsRoom(false);
                },
                icon: MdiIcons.close,
                title: "NO",
                subtitle: "Not necessary",
                bgColor: needProvider.getSportsRoom ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                themeColor: needProvider.getSportsRoom ? Colors.grey[700] : Colors.white,
                subtitleColor: needProvider.getSportsRoom ? Colors.grey : Colors.white.withOpacity(0.7),
              ),
            ],
          ),
          Container(
            height: hv*20,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: wv*15),
            child: Text(
              needProvider.getSportsRoom ? 
              "A space suited for a sports room will be added to your request" : 
              "No extra space suited for a sports room will be added to your request",
              style: TextStyle(fontSize: wv*4),
              textAlign: TextAlign.center,),
          ),
          SizedBox(
            width: wv*84,
            child: !loading ? RaisedButton(
              onPressed: (){sendHouseRequest(context);},
              padding: EdgeInsets.symmetric(vertical: hv*1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Conirm and Send", style: TextStyle(color: Colors.white, fontSize: wv*4, fontWeight: FontWeight.w700),),
                  SizedBox(width: 5,),
                  Icon(Icons.arrow_forward, color: Colors.white)
                ],
              ),
            )
            :
            Center(child: CircularProgressIndicator())
            ,
          )
        ],
      ),
    );
  }

    void sendHouseRequest(BuildContext context){
    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    NeedProvider needProvider = Provider.of<NeedProvider>(context, listen: false);
    setState(() {
      loading = true;
    });
    FirebaseFirestore.instance
      .collection("HouseRequest")
      .doc(userProfileProvider.getId + "-" + DateTime.now().millisecondsSinceEpoch.toString())
      .set({
    "customerId": userProfileProvider.getId,
    "customerName": userProfileProvider.getName,
    "customerEmail": userProfileProvider.getEmail,
    "living-room": needProvider.getLivingRoom,
    "kitchen": needProvider.getKitchen,
    "bedroom": needProvider.getBedroom,
    "bathroom": needProvider.getBathroom,
    "sports-room": needProvider.getSportsRoom,
    "office-library": needProvider.getOfficeLibrary,
    "surfaceMoreThan350": needProvider.getSurface,
    "timeAdded": DateTime.now().millisecondsSinceEpoch.toString()
  }).then((value)  {
    setState(() {
      loading = false;
    });
    Navigator.pushNamed(context, '/needOutput');
  }).catchError((onError){
    setState(() {
      loading = false;
    });
    Fluttertoast.showToast(msg: "An unexpected error occured, check your internet connection and try again please", backgroundColor: Colors.red);
  }) ;
  setState(() {
      loading = false;
    });
  }

}
