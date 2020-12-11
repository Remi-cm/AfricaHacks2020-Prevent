import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  CustomAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}