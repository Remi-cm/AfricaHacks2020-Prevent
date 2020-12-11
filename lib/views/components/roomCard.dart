import 'package:Prevent/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomCard extends StatelessWidget {
  final IconData icon;
  final int title;
  final String subtitle;
  final Function action;
  final Color themeColor;
  final Color bgColor;
  final Color subtitleColor;
  final Function remove;
  final Function add;

  const RoomCard({Key key, this.title, this.action, this.themeColor, this.bgColor, this.subtitle, this.subtitleColor, this.icon, this.add, this.remove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: EdgeInsets.only(top: wv*3, bottom: wv*3),
        width: wv * 40,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: wv*15,color: themeProvider.mode == ThemeMode.light ? themeColor : Colors.white),
            SizedBox(height: hv*3,),
            //Text(title, style: TextStyle(fontSize: wv*10, fontWeight: FontWeight.w900),),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: remove,
                  child: CircleAvatar(
                    radius: wv*3,
                    backgroundColor: title <= 1 ? Colors.grey[400] : Theme.of(context).primaryColor,
                    child: Icon(Icons.remove, size: wv*4, color: Colors.white,),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wv*2),
                  child: Text(
                    title.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: hv*5,
                        fontWeight: FontWeight.w600,
                        color: themeProvider.mode == ThemeMode.light ? themeColor : Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: add,
                  child: CircleAvatar(
                    radius: wv*3,
                    backgroundColor: title >= 8 ? Colors.grey[400] : Theme.of(context).primaryColor,
                    child: Icon(Icons.add, color: Colors.white, size: wv*4,),
                  ),
                ),
              ],
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: hv*2,
                  fontWeight: FontWeight.w800,
                  color: themeProvider.mode == ThemeMode.light ? subtitleColor : Colors.white.withOpacity(0.3)),
            )
          ],
        ),
      ),
    );
  }
}
