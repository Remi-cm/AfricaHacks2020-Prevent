import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({
    Key key,
    @required this.pageTitle,
    this.photoPath,
    this.color,
    this.titleColor,
    this.elevated = false,
  })  : assert(pageTitle != null),
        assert(elevated != null),
        super(
          toolbarHeight: 60,
          key: key,
          elevation: elevated ? 1 : 0,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 16,
              splashRadius: 20,
              onPressed: () {
                Navigator.pop(context);
              },
              constraints: BoxConstraints(
                maxWidth: 16,
                maxHeight: 16,
              ),
            );
          }),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              photoPath != null
                  ? ClipOval(
                      child: Image(
                        image: AssetImage('assets/images/bg.png'),
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox.shrink(),
              photoPath != null ? SizedBox(width: 12) : SizedBox.shrink(),
              Text(
                pageTitle,
                style: TextStyle(
                  fontFamily: "Avenir Next LT Pro",
                ),
              )
            ],
          ),
        );

  final String pageTitle;
  final String photoPath;
  final Color color;
  final Color titleColor;
  final bool elevated;
}
