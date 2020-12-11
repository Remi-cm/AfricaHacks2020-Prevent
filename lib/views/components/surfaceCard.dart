import 'package:Prevent/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurfaceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Function action;
  final Color themeColor;
  final Color bgColor;
  final Color subtitleColor;

  const SurfaceCard({Key key, this.title, this.action, this.themeColor, this.bgColor, this.subtitle, this.subtitleColor, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: EdgeInsets.only(top: wv*7, bottom: wv*7, left: wv*7),
        width: wv * 40,
        height: wv * 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(wv*3),
          color: bgColor,
          boxShadow: [
            BoxShadow(
                color: themeProvider.mode == ThemeMode.light ? Colors.grey.withOpacity(0.2) : bgColor.withOpacity(0.0),
                offset: new Offset(0.0, 0.0),
                blurRadius: 4,
                spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: wv*15,color: themeProvider.mode == ThemeMode.light ? themeColor : Colors.white),
            //Text(title, style: TextStyle(fontSize: wv*10, fontWeight: FontWeight.w900),),
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
