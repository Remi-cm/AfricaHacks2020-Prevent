import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeModel with ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.light ? false : true;
  ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setPhoneTheme() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    _mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
