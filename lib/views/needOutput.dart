import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Prevent/models/product.dart';
import 'package:Prevent/providers/needProvider.dart';
import 'package:Prevent/views/results.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class NeedOutput extends StatefulWidget {
  @override
  _NeedOutputState createState() => _NeedOutputState();
}

class _NeedOutputState extends State<NeedOutput> {
    getResults() {
    final needProvider = Provider.of<NeedProvider>(context, listen: false);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Products")
          //.where("price", isLessThanOrEqualTo: userBudgetProvider.getBudget)
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
              Text("Sorry! No houses available", 
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
    final needProvider = Provider.of<NeedProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: hv*5,),
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: wv*15,
                child: Icon(Icons.check, size: wv*20, color:  Colors.white,),
              ),
              SizedBox(height: hv*2,),
              Text("Your request was successfully\nsent to the PISA team", style: TextStyle(fontSize: wv*4.5, fontWeight: FontWeight.w800), textAlign: TextAlign.center,),
              SizedBox(height: hv*2,),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: (){ Navigator.pushReplacementNamed(context, '/home'); },
                child: Text("Go back home", style: TextStyle(color: Colors.white),), 
              ),
              SizedBox(height: hv*2,),
              Text("Checkout some of our best products", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
              SizedBox(height: hv*1,),

              getResults(),

            ],
          ),
        ),
      ),
    );
  }
}