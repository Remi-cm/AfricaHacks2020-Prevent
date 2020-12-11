import 'package:flutter/material.dart';

class UserBudgetProvider with ChangeNotifier {
  int _budget;

  UserBudgetProvider(this._budget);

  int get getBudget => _budget;

  void setBudget(int newVal) {
    _budget = newVal;
    notifyListeners();
  }

}
