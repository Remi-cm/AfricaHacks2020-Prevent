import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/providers/productProvider.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  TextEditingController phoneController = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  String dateChoosen = "Select a date";
  String phone;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    ProductProvider prodProvider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeModel>(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
  String subject = prodProvider.getId == "consulting" ?
      "Consulting appointment request by user '${userProfileProvider.getName}' to the PISA team. \n(Subject Is Not Editable)"
     : "Discussion about the realization of the product '${prodProvider.getLabel}' between user '${userProfileProvider.getName}' and the PISA team \n(Subject Is Not Editable)";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Appointment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: wv*2),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Customer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: hv*1,),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: themeProvider.mode == ThemeMode.light ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.0),
                          offset: new Offset(0.0, 0.0),
                          blurRadius: 3,
                          spreadRadius: 3),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: userProfileProvider.getAvatar != null
                          ? CachedNetworkImageProvider(userProfileProvider.getAvatar)
                          : AssetImage("assets/images/avatar.png"),
                    ),
                    title: Text(userProfileProvider.getName),
                    subtitle: Text(userProfileProvider.getEmail),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),

                SizedBox(height: hv*3,),

                Text("Subject", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: hv*1,),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: themeProvider.mode == ThemeMode.light
                          ? Colors.grey[100]
                          : Colors.black45,
                    ),
                    child: Text(subject,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400])),
                ),

                SizedBox(height: hv*3,),
                Text("Preferred Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: hv*1,),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: hv * 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: themeProvider.mode == ThemeMode.light
                          ? Colors.grey[100]
                          : Colors.black45,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(dateChoosen,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400])),
                        Icon(Icons.calendar_today, color: Colors.grey[400],),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: hv*3,),

                Text("Venue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: hv*1,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  height: hv * 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: themeProvider.mode == ThemeMode.light
                        ? Colors.grey[100]
                        : Colors.black45,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Online | Zoom or Skype",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400])),
                      Icon(Icons.arrow_drop_down, color: Colors.grey[400],),
                    ],
                  ),
                ),
                SizedBox(height: 3,),
                Align(alignment: Alignment.centerRight ,child: Text("Only online appointments for now", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor ))),

                SizedBox(height: hv*3,),

                Text("Phone Number", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: hv*1,),
                IntlPhoneField(
                  controller: phoneController,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone, color: Colors.grey.withOpacity(0.7)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(15)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.grey[400]),
                          fillColor: Colors.grey.withOpacity(0.1),
                          contentPadding: EdgeInsets.all(hv*1),
                          filled: true,
                  ),
                  initialCountryCode: 'CM',
                  onChanged: (val) {
                      print(val.completeNumber);
                      phone = val.completeNumber;
                  },
              ),

              SizedBox(height: hv*4,),

              !loading ? Container(
                width: double.infinity,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: dateChoosen != "Select a date" && phoneController.text.isNotEmpty ? 
                    (){confirmAppointment(context);}
                  : null,
                  padding: EdgeInsets.symmetric(vertical: hv*2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Theme.of(context).primaryColor,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Confirm",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: hv * 2.2,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.arrow_forward, color: Colors.white,)
                    ],
                  ))
                  
              ): Center(child: CircularProgressIndicator()),

              SizedBox(height: hv*4,),


                
            ],),
          )
        ],
      ),
    );
  }

  void confirmAppointment (BuildContext context){
    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    ProductProvider prodProvider = Provider.of<ProductProvider>(context, listen: false);
    String subject = prodProvider.getId == "consulting" ?
      "Consulting appointment request by user '${userProfileProvider.getName}'"
     : "Discussion about the realization of the product '${prodProvider.getLabel}' between user '${userProfileProvider.getName}' and the PISA team";
    setState(() {
      loading = false;
    });
    print(phone);
    FirebaseFirestore.instance
      .collection("Appointments")
      .doc(userProfileProvider.getId + "-" + DateTime.now().millisecondsSinceEpoch.toString())
      .set({
    "customerId": userProfileProvider.getId,
    "customerName": userProfileProvider.getName,
    "customerEmail": userProfileProvider.getEmail,
    "subject": subject,
    "preferredDate": dateChoosen,
    "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
    "phone": phone,
    "venue": "Online",
  }).then((value)  {
    setState(() {
      loading = false;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FeedbackDialogBox(
          content: "Your appointment was successfully registered. We'll get back to you very soon for more details",
          user: userProfileProvider,
        );
      });
  }).catchError((onError){
    setState(() {
      loading = false;
    });
    Fluttertoast.showToast(msg: "An unexpected error occured, check your internet connection and try again please");
  }) ;
  setState(() {
      loading = false;
    });
  }

    Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2021));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateChoosen = "${picked.toLocal()}".split(' ')[0];
      });
  }
}

class FeedbackDialogBox extends StatelessWidget {
  final String content;
  final UserProfileProvider user;

  const FeedbackDialogBox(
      {Key key, this.content, this.user})
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
    double avatarRadius = wv*10;
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
                  "Order Confirmed",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  content,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 22,
                ),
                FlatButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/home');
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.green[700], 
                  child: Text("Go back to home page", style: TextStyle(color: Colors.white),)),
              ],
            ),
          ), // bottom part
          Positioned(
            left: padding,
            right: padding,
            child: CircleAvatar(
              backgroundColor: Colors.green[700],
              radius: avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Icon(Icons.check, size: 50, color: Colors.white,),
              ),
            ),
          ) // top part
        ],
      ),
    );
  }
}