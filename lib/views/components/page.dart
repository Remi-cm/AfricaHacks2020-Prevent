import 'package:flutter/material.dart';

import 'app_bar.dart';

class MyPage extends StatelessWidget {
  const MyPage({
    Key key,
    @required this.title,
    this.appBarImage,
    this.appBarColor,
    @required this.child,
    this.elevated = false,
  })  : assert(title != null),
        assert(elevated != null),
        assert(child != null),
        super(key: key);

  final String title;
  final String appBarImage;
  final Color appBarColor;
  final bool elevated;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        pageTitle: title,
        photoPath: appBarImage,
        color: appBarColor,
        elevated: elevated,
      ),
      body: child,
    );
  }
}
