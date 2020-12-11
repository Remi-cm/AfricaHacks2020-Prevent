import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Prevent/helpers/guest.dart';
import 'package:Prevent/providers/guestStatusProvider.dart';
import 'package:Prevent/providers/productProvider.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProductDetails extends StatelessWidget {
  final formatCurrency = new NumberFormat.currency(name: 'FCFA ');
  @override
  Widget build(BuildContext context) {
  CarouselController buttonCarouselController = CarouselController();
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    ProductProvider prodProvider = Provider.of<ProductProvider>(context);
    GuestStatusProvider guestProvider = Provider.of<GuestStatusProvider>(context);
    final themeProvider = Provider.of<ThemeModel>(context);

    carouselItem ({String imgPath, String label}) {
      return GestureDetector(
        onTap: () => _showFullImage(context, imgPath),
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 0.0),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: themeProvider.mode == ThemeMode.light ? Colors.grey.withOpacity(0.3) : Colors.grey.withOpacity(0.0),
                  offset: new Offset(0.0, 0.0),
                  blurRadius: 4,
                  spreadRadius: 4),
            ],
            image: DecorationImage(image: CachedNetworkImageProvider(imgPath), fit: BoxFit.fill),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Colors.white),),
            ],
          )
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Expanded(child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/pisaLogo.jpg'),
                  radius: 17,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: Text(prodProvider.getLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700), overflow: TextOverflow.fade,)),
              ],
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.brown.withOpacity(0.9)
              ),
              child: Text("${prodProvider.getSurface} m²", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),)
            )
          ],
        )
      ),
      body: ListView(children: <Widget>[
        Stack(
          children: <Widget>[
            CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                pauseAutoPlayOnManualNavigate: true,
                height: hv*25,
                aspectRatio: 16/9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: prodProvider.getImages.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: carouselItem(imgPath: url, label: "${prodProvider.getLabel} Image"),
                    );
                  },
                );
              }).toList(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: wv*2),
              height: hv*25,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    child: IconButton(icon: Icon(Icons.arrow_back_ios), iconSize: 14, color: Colors.grey[200], onPressed: (){buttonCarouselController.previousPage();}), 
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  CircleAvatar(
                    child: IconButton(icon: Icon(Icons.arrow_forward_ios), iconSize: 14, color: Colors.white, onPressed: (){buttonCarouselController.nextPage();}), 
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
              ],),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
          margin: EdgeInsets.symmetric(horizontal: wv*2, vertical: hv*1),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Description:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),),
              SizedBox(height: 5,),
              Text(prodProvider.getDescription, style: TextStyle(color: Colors.white) ,),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: hv*1.5, horizontal: wv*2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Rooms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: wv*3,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  roomCard(context: context, icon: MdiIcons.homeHeart, title: "Living Room", quantity:  prodProvider.getLivingRoom, color: Colors.brown[700].withOpacity(0.7)),
                  SizedBox(width: wv*3,),
                  roomCard(context: context, icon: Icons.kitchen, title: "kitchen", quantity: prodProvider.getKitchen, color: Colors.green[900].withOpacity(0.7))
                ],
              ),
              SizedBox(height: wv*3),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  roomCard(context: context, icon: MdiIcons.bedOutline, title: "Bed Room", quantity: prodProvider.getBedroom, color: Colors.orange.withOpacity(0.7)),
                  SizedBox(width: wv*3,),
                  roomCard(context: context, icon: Icons.wc, title: "Bath Room", quantity: prodProvider.getBathroom, color: Colors.blue.withOpacity(0.7))
                ],
              ),
            ],
          ),
        ),
        ((prodProvider.getOfficeLibrary != null) || (prodProvider.getSportsRoom != null)) ? Container(
          padding: EdgeInsets.symmetric(vertical: hv*1.5, horizontal: wv*3),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Extra Facilities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: wv*3,),
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  prodProvider.getOfficeLibrary != null ? roomCard(context: context, icon: MdiIcons.homeHeart, title: "Office or Library", quantity:  prodProvider.getOfficeLibrary, color: Colors.brown[700].withOpacity(0.7)) : Container(),
                  prodProvider.getSportsRoom != null ? SizedBox(width: wv*3,) : Container(),
                  prodProvider.getSportsRoom != null ? roomCard(context: context, icon: Icons.kitchen, title: "Sports Room", quantity: prodProvider.getSportsRoom, color: Colors.green[900].withOpacity(0.7)) : Container()
                ],
              ),
              SizedBox(height: wv*3),
            ],
          ),
        ) : Container(),
        Container(
          padding: EdgeInsets.symmetric(vertical: hv*1.5, horizontal: wv*2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Cost Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: wv*3,),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: themeProvider.mode == ThemeMode.light ? Theme.of(context).primaryColor : Colors.black87,
                  child: Icon(MdiIcons.grain, color: Colors.white),
                ),
                title: Text("Sand"),
                trailing: Text("${formatCurrency.format(prodProvider.getSandCost)}"),
              ),
              Divider(height: 0,),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: themeProvider.mode == ThemeMode.light ? Theme.of(context).primaryColor : Colors.black87,
                  child: Icon(MdiIcons.salesforce, color: Colors.white),
                ),
                title: Text("Soil"),
                trailing: Text("${formatCurrency.format(prodProvider.getSoilCost)}"),
              ),
              Divider(height: 0,),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: themeProvider.mode == ThemeMode.light ? Theme.of(context).primaryColor : Colors.black87,
                  child: Icon(MdiIcons.decagram, color: Colors.white),
                ),
                title: Text("Cement"),
                trailing: Text("${formatCurrency.format(prodProvider.getCementCost)}"),
              ),
              Divider(height: 0,),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: themeProvider.mode == ThemeMode.light ? Theme.of(context).primaryColor : Colors.black87,
                  child: Icon(MdiIcons.windowClosedVariant, color: Colors.white),
                ),
                title: Text("Windows and Doors"),
                trailing: Text("${formatCurrency.format(prodProvider.getWindowsAndDoorsCost)}"),
              ),
              Divider(height: 0,),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: themeProvider.mode == ThemeMode.light ? Theme.of(context).primaryColor : Colors.black87,
                  child: Icon(MdiIcons.garageOpenVariant, color: Colors.white),
                ),
                title: Text("Roofing"),
                trailing: Text("${formatCurrency.format(prodProvider.getRoofingCost)}"),
              ),
              Divider(height: 0,),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: themeProvider.mode == ThemeMode.light ? Theme.of(context).primaryColor : Colors.black87,
                  child: Icon(Icons.scatter_plot, color: Colors.white),
                ),
                title: Text("Miscellaneous"),
                trailing: Text("${formatCurrency.format(prodProvider.getMiscellaneousCost)}"),
              ),
              Divider(height: 0,),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: themeProvider.mode == ThemeMode.light ? Theme.of(context).primaryColor : Colors.black87,
                  child: Icon(MdiIcons.armFlexOutline, color: Colors.white,),
                ),
                title: Text("Workmanship"),
                trailing: Text("${formatCurrency.format(prodProvider.getWorkmanshipCost)}"),
              ),
              Divider(height: 7,),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(MdiIcons.plusCircleMultipleOutline, color: Theme.of(context).primaryColor,),
                  ),
                  title: Text("Total", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
                  trailing: Text("${formatCurrency.format(prodProvider.getTotalCost)}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: hv*1,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: wv*2),
          child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: themeProvider.mode == ThemeMode.light ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.0),
                  offset: new Offset(0.0, 0.0),
                  blurRadius: 2,
                  spreadRadius: 2),
            ],
            ),
            child: FlatButton(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(vertical: hv*1),
              onPressed: (){
                !guestProvider.isGuest ? Navigator.pushNamed(context, '/appointment') : GuestOperations().askSignIn(context);
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/pisaLogo.jpg'),
                    radius: wv*5,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Make Appointment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
              ],),
            ),
          ),
        ),
        SizedBox(height: hv*4,)
      ],),
    );
    
  }
  void _showFullImage(BuildContext context, String url){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: CachedNetworkImage(imageUrl: url,),
              ),
              IconButton(icon: Icon(Icons.arrow_back), onPressed: Navigator.of(context).pop )
            ],
          ),
        ),
      ))
    );
  }

  roomCard({BuildContext context, IconData icon, String title, int quantity, Color color}) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    final themeProvider = Provider.of<ThemeModel>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: hv*2),
      width: wv*45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(wv*2),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
              color: themeProvider.mode == ThemeMode.light ? Colors.grey.withOpacity(0.3) : Colors.grey.withOpacity(0.0),
              offset: new Offset(0.0, 0.0),
              blurRadius: 4,
              spreadRadius: 2),
        ],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            child: Icon(icon, size: wv*7, color: Colors.white,), 
            radius: wv*7, 
            backgroundColor: color),
          SizedBox(height: hv*1),
          Text(title),
          SizedBox(height: hv*1),
          Text("${quantity.toString()}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
        ],
      ),);
  }
}
