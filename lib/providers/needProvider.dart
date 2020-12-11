import 'package:flutter/material.dart';

class NeedProvider with ChangeNotifier {
  bool _surfaceIsLarge;
  int _livingRoom;
  int _kitchen;
  int _bedroom;
  int _bathroom;
  bool _officeLibrary;
  bool _sportsRoom;

  NeedProvider(this._surfaceIsLarge, this._livingRoom, this._kitchen, this._bedroom, this._bathroom, this._officeLibrary, this._sportsRoom);

  bool get getSurface => _surfaceIsLarge;
  int get getLivingRoom => _livingRoom;
  int get getKitchen => _kitchen;
  int get getBedroom => _bedroom;
  int get getBathroom => _bathroom;
  bool get getOfficeLibrary => _officeLibrary;
  bool get getSportsRoom => _sportsRoom;

  void setSurface(bool newVal) {
    _surfaceIsLarge = newVal;
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
  void setOfficeLibrary(bool newVal) {
    _officeLibrary = newVal;
    notifyListeners();
  }
  void setSportsRoom(bool newVal) {
    _sportsRoom = newVal;
    notifyListeners();
  }
  
}