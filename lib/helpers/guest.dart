import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GuestOperations {
  askSignIn(BuildContext context){
    contentBox(BuildContext context) {
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
                    "Sign In",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "This operation requires you to be signed in",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);},
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color:  Theme.of(context).primaryColor, 
                        child: Text("Confirm", style: TextStyle(color: Colors.white),)),

                      SizedBox(width: 10,),
                        
                      FlatButton(onPressed: (){
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color:  Colors.red, 
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
    
    Widget buildDialog(){
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildDialog();
    });
  }
}