import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  Color _appThemeColor = const Color.fromARGB(255, 233, 117, 63);

  Color get appThemeColor => _appThemeColor;

  set appThemeColor(Color color) {
    _appThemeColor = color;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }
}
