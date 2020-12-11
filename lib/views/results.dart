
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/models/product.dart';
import 'package:Prevent/providers/productProvider.dart';
import 'package:Prevent/providers/themeProvider.dart';
import 'package:Prevent/providers/userBudgetProvider.dart';
import 'package:Prevent/providers/userProfileProvider.dart';
import 'package:Prevent/views/services.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  int length = 0;
  TextEditingController budgetDialogInputController = new TextEditingController();
  final formatCurrency = new NumberFormat.currency(name: 'FCFA ');

  getResultsLength () {
    UserBudgetProvider userBudgetProvider = Provider.of<UserBudgetProvider>(context, listen: false);
      return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Products")
          .where("price", isLessThanOrEqualTo: userBudgetProvider.getBudget)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Results (0)", style: TextStyle(fontWeight: FontWeight.w800));
        }
        return Text("Results (${snapshot.data.documents.length})", style: TextStyle(fontWeight: FontWeight.w800));
      },
    );
  }

  getResults () {
    UserBudgetProvider userBudgetProvider = Provider.of<UserBudgetProvider>(context, listen: false);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Products")
          .where("price", isLessThanOrEqualTo: userBudgetProvider.getBudget)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.data.documents.length >= 1 ? Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                length = length + 1;
                DocumentSnapshot doc = snapshot.data.documents[index];
                ProductModel product = ProductModel.fromDocument(doc);
                return ProductTile(
                  product: product,
                );
              },
            ),
          ),
        ) :
        Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Icon(MdiIcons.databaseRemove, color: Colors.grey[400], size: 85,),
              SizedBox(height: 5,),
              Text("Sorry! No houses available for :\n ${userBudgetProvider.getBudget} FCFA", 
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
              , textAlign: TextAlign.center,),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    UserBudgetProvider userBudgetProvider = Provider.of<UserBudgetProvider>(context);
    final themeProvider = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Row(crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("Budget : ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800), ),
            Expanded(child: Text(formatCurrency.format(userBudgetProvider.getBudget), overflow: TextOverflow.fade, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, ))),
          ],
        ),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: wv*2),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getResultsLength(),
              RaisedButton(onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReplyDialogBox(
                      name: "Input your Budget",
                      content:"ex: 500000",
                      user: Provider.of<UserProfileProvider>(context),
                      inputController: budgetDialogInputController,
                      fromService: false,
                    );
                  });
              },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: Text("New Budget", style: TextStyle(color: Colors.white),),)
            ],
          ),
        ),
        getResults(),
      ],),
    );
  }
}

class ProductTile extends StatelessWidget {
  final ProductModel product;

  const ProductTile({
    Key key,
    this.product
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final hv = MediaQuery.of(context).size.height / 100;
    final wv = MediaQuery.of(context).size.width / 100;
    return Container(
      margin: EdgeInsets.symmetric(vertical: hv*1, horizontal: wv*2),
      decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          productDetails(context);
        },
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: <Widget>[
             Container(
                  height: hv*10, width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                  color: Colors.grey,
                    image: DecorationImage(image:product.images != null
                      ? CachedNetworkImageProvider(product.images[0])
                      : AssetImage("assets/images/avatar.png"), fit: BoxFit.fill)
                  ),
                ),
            Expanded(
              child: SizedBox(
                height: hv*10,
                child: ListTile(
                  title: Text(product.label, style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(product.description, overflow: TextOverflow.ellipsis,),
                  //subtitle: Text("Joined: " + DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch((int.parse(user.createdAt))))),
                  trailing: Text("${product.totalCost} FCFA", style: TextStyle(fontWeight: FontWeight.w800),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  productDetails(BuildContext context) {

    ProductProvider prodProvider = Provider.of<ProductProvider>(context, listen: false);

    prodProvider.setId(product.id);
    prodProvider.setLabel(product.label);
    prodProvider.setDescription(product.description);
    prodProvider.setImages(product.images);
    prodProvider.setSandCost(product.sandCost);
    prodProvider.setSoilCost(product.soilCost);
    prodProvider.setCementCost(product.cementCost);
    prodProvider.setWindowsAndDoorsCost(product.windowsAndDoorsCost);
    prodProvider.setRoofingCost(product.roofingCost);
    prodProvider.setMiscellaneousCost(product.miscellaneousCost);
    prodProvider.setWorkmanshipCost(product.workmanshipCost);
    prodProvider.setTotalCost(product.totalCost);
    prodProvider.setSurface(product.surface);
    prodProvider.setLivingRoom(product.livingRoom);
    prodProvider.setKitchen(product.kitchen);
    prodProvider.setBedroom(product.bedroom);
    prodProvider.setBathroom(product.bathroom);
    prodProvider.setOfficeLibrary(product.officeLibrary);
    prodProvider.setSportsRoom(product.sportsRoom);

    Navigator.pushNamed(context, '/productDetails');

    print("details");
  }
}