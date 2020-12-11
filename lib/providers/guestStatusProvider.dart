import 'package:flutter/material.dart';

class GuestStatusProvider with ChangeNotifier {
  bool _isGuest;

  GuestStatusProvider(this._isGuest);

  bool get isGuest => _isGuest;

  void setStatus(bool newVal) {
    _isGuest = newVal;
    notifyListeners();
  }

}
