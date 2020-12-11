import 'package:flutter/material.dart';

import 'page.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({
    Key key,
    this.title,
    this.statusMessage,
    this.numLikes,
    this.liked,
    this.name,
    this.location,
    this.dateTime,
    this.phone,
    this.child,
    this.elevated,
  })  : assert(title != null),
        assert(numLikes != null),
        assert(liked != null),
        assert(statusMessage != null),
        assert(name != null),
        assert(location != null),
        assert((dateTime != null) || (phone != null)),
        assert(child != null),
        super(key: key);

  final String title;
  final bool elevated;
  final String statusMessage;
  final int numLikes;
  final bool liked;
  final String name;
  final String location;
  final String dateTime;
  final String phone;
  final Widget child;

  Widget _buildIconPrefixedText({IconData icon, String image, String text}) {
    return Row(
      children: [
        icon != null
            ? Icon(
                icon,
                size: 16,
              )
            : image != null
                ? ImageIcon(
                    AssetImage("assets/icons/clock_black.png"),
                    size: 16,
                  )
                : null,
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontFamily: "Avenir Next LT Pro",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    return MyPage(
      title: title,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.01),
        child: Card(
          elevation: 4.0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Container(
            constraints: BoxConstraints(minHeight: height * 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$numLikes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: "Lato",
                                letterSpacing: 1.67,
                              ),
                            ),
                            SizedBox(width: 6),
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.favorite),
                              onPressed: () {},
                              iconSize: 16,
                              constraints: BoxConstraints(
                                maxWidth: 16,
                                maxHeight: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 15),
                          child: Text(
                            statusMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontFamily: "Avenir Next LT Pro",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: height * 0.15,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$name",
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: "Avenir Next LT Pro",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          _buildIconPrefixedText(
                            icon: Icons.location_on,
                            text: "$location",
                          ),
                          dateTime != null
                              ? _buildIconPrefixedText(
                                  image: 'clock_black',
                                  text: "$dateTime",
                                )
                              : phone != null
                                  ? _buildIconPrefixedText(
                                      icon: Icons.phone,
                                      text: "$phone",
                                    )
                                  : null,
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: child,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
