import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  String _id;
  String _label;
  String _description;
  List _images;
  int _sandCost;
  int _soilCost;
  int _windowsAndDoorsCost;
  int _workmanshipCost;
  int _roofingCost;
  int _miscellaneousCost;
  int _cementCost;
  int _totalCost;
  int _surface;
  int _livingRoom;
  int _kitchen;
  int _bedroom;
  int _bathroom;
  int _officeLibrary;
  int _sportsRoom;

  ProductProvider(this._id, this._label, this._description, this._images, this._sandCost, this._soilCost, this._windowsAndDoorsCost, this._workmanshipCost, this._roofingCost, this._miscellaneousCost, this._cementCost, this._totalCost, this._surface, this._livingRoom, this._kitchen, this._bedroom, this._bathroom, this._officeLibrary, this._sportsRoom);
  
  String get getId => _id;
  String get getLabel => _label;
  String get getDescription => _description;
  List get getImages => _images;
  int get getSandCost => _sandCost;
  int get getSoilCost => _soilCost;
  int get getWindowsAndDoorsCost => _windowsAndDoorsCost;
  int get getWorkmanshipCost => _workmanshipCost;
  int get getRoofingCost => _roofingCost;
  int get getMiscellaneousCost => _miscellaneousCost;
  int get getCementCost => _cementCost;
  int get getTotalCost => _totalCost;
  int get getSurface => _surface;
  int get getLivingRoom => _livingRoom;
  int get getKitchen => _kitchen;
  int get getBedroom => _bedroom;
  int get getBathroom => _bathroom;
  int get getOfficeLibrary => _officeLibrary;
  int get getSportsRoom => _sportsRoom;

  void setId(String newVal) {
    _id = newVal;
    notifyListeners();
  }
    void setLabel(String newVal) {
    _label = newVal;
    notifyListeners();
  }
    void setDescription(String newVal) {
    _description = newVal;
    notifyListeners();
  }
    void setImages(List newVal) {
    _images = newVal;
    notifyListeners();
  }
  void setSandCost(int newVal) {
    _sandCost = newVal;
    notifyListeners();
  }
  void setSoilCost(int newVal) {
    _soilCost = newVal;
    notifyListeners();
  }
  void setCementCost(int newVal) {
    _cementCost = newVal;
    notifyListeners();
  }
  void setWindowsAndDoorsCost(int newVal) {
    _windowsAndDoorsCost = newVal;
    notifyListeners();
  }
  void setRoofingCost(int newVal) {
    _roofingCost = newVal;
    notifyListeners();
  }
  void setMiscellaneousCost(int newVal) {
    _miscellaneousCost = newVal;
    notifyListeners();
  }
  void setWorkmanshipCost(int newVal) {
    _workmanshipCost = newVal;
    notifyListeners();
  }
  void setTotalCost(int newVal) {
    _totalCost = newVal;
    notifyListeners();
  }
  void setSurface(int newVal) {
    _surface = newVal;
    notifyListeners();
  }
  void setLivingRoom(int newVal) {
    _livingRoom = newVal;
    notifyListeners();
  }
  void setKitchen(int newVal) {
    _kitchen = newVal;
    notifyListeners();
  }
  void setBedroom(int newVal) {
    _bedroom = newVal;
    notifyListeners();
  }
  void setBathroom(int newVal) {
    _bathroom = newVal;
    notifyListeners();
  }
  void setOfficeLibrary(int newVal) {
    _officeLibrary = newVal;
    notifyListeners();
  }
  void setSportsRoom(int newVal) {
    _sportsRoom = newVal;
    notifyListeners();
  }
  
}