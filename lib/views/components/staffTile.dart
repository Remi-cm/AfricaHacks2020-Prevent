import 'package:cached_network_image/cached_network_image.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffTile extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String title;
  final String email;
  final Function action;

  const StaffTile({Key key, this.name, this.title, this.email, this.action, this.avatarUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    final wv = MediaQuery.of(context).size.width / 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: action,
        child: Container(
          width: wv * 62,
          padding: EdgeInsets.symmetric(horizontal: wv * 3),
          margin: EdgeInsets.symmetric(horizontal: wv * 2),
          decoration: BoxDecoration(
              color:  Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: avatarUrl != null
                    ? CachedNetworkImageProvider(avatarUrl)
                    : AssetImage("assets/images/avatar.png"),
                radius: wv * 7,
              ),
              SizedBox(
                width: wv * 2,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$name",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: themeProvider.mode == ThemeMode.light
                              ? Colors.grey[700]
                              : Colors.white),
                    ),
                    Text(title,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w300)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(email,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: themeProvider.mode == ThemeMode.light ? Theme.of(context).primaryColor : Colors.white.withOpacity(1)))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
