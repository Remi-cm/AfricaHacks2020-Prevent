import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String label;
  final String description;
  final List images;
  final int sandCost;
  final int soilCost;
  final int windowsAndDoorsCost;
  final int workmanshipCost;
  final int roofingCost;
  final int miscellaneousCost;
  final int cementCost;
  final int totalCost;
  final int surface;
  final int livingRoom;
  final int kitchen;
  final int bedroom;
  final int bathroom;
  final int officeLibrary;
  final int sportsRoom;

  ProductModel({this.label, this.description, this.images, this.sandCost, this.soilCost, this.windowsAndDoorsCost, this.workmanshipCost, this.roofingCost, this.miscellaneousCost, this.cementCost, this.totalCost, this.id, this.bathroom, this.bedroom, this.kitchen, this.livingRoom, this.officeLibrary, this.sportsRoom, this.surface});

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    return ProductModel(
      id: doc.id,
      label: doc.data()["label"],
      description: doc.data()["description"],
      images: doc.data()["images"],
      sandCost: doc.data()["sand"],
      soilCost: doc.data()["soil"],
      windowsAndDoorsCost: doc.data()["windows-doors"],
      workmanshipCost: doc.data()["workmanship"],
      roofingCost: doc.data()["roofing"],
      miscellaneousCost: doc.data()["miscellaneous"],
      cementCost: doc.data()["cement"],
      totalCost: doc.data()["price"],
      surface: doc.data()["surface"],
      livingRoom: doc.data()["living-room"],
      kitchen: doc.data()["kitchen"],
      bedroom: doc.data()["bedroom"],
      bathroom: doc.data()["bathroom"],
      officeLibrary: doc.data()["office-library"],
      sportsRoom: doc.data()["sports-room"],
    );
  }
}
