import 'package:flutter/material.dart';

class LogoAndSlogan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    return Column(
      children: <Widget>[
        Hero(
          tag: "logo",
          child: Container(
            padding: EdgeInsets.all(hv * 1.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2)),
            child: CircleAvatar(
                radius: hv * 4,
                backgroundColor: Theme.of(context).primaryColor,
                backgroundImage: AssetImage('assets/images/pisaLogo.jpg'),),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Prevent",
                  style: TextStyle(
                      fontSize: hv * 3.8,
                      fontWeight: FontWeight.w900)),
              Text("Mobile",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      fontSize: hv * 3.9,
                      fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        Text("Our safety is our duty",
            style: TextStyle(
                fontSize: hv * 1.8,
                fontWeight: FontWeight.w800)),
      ],
    );
  }
}
