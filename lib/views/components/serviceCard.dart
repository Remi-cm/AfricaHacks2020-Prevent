import 'package:Prevent/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Function action;
  final Color themeColor;
  final Color bgColor;
  final Color subtitleColor;

  const ServiceCard({Key key, this.icon, this.title, this.action, this.themeColor, this.bgColor, this.subtitle, this.subtitleColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: EdgeInsets.only(top: wv*7, bottom: wv*7, left: wv*7),
        width: wv * 46,
        height: wv * 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(wv*7),
          color: bgColor,
          boxShadow: [
            BoxShadow(
                color: themeProvider.mode == ThemeMode.light ? Colors.grey.withOpacity(0.2) : bgColor.withOpacity(0.0),
                offset: new Offset(0.0, 0.0),
                blurRadius: 4,
                spreadRadius: 4),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
                  icon,
                  color: bgColor == Colors.white ? Theme.of(context).primaryColor.withOpacity(0.7) : Colors.white,
                  size: wv*15,
                ),
            SizedBox(
              height: hv * 1,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: hv*2.5,
                      fontWeight: FontWeight.w700,
                      color: themeProvider.mode == ThemeMode.light ? themeColor : Colors.white),
                ),
                
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: hv*1.5,
                      fontWeight: FontWeight.w800,
                      color: themeProvider.mode == ThemeMode.light ? subtitleColor : Colors.white.withOpacity(0.3)),
            )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
