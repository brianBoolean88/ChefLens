import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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

  void initializeColorGlobal() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/123');

    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        _appThemeColor = data['appThemeColor'];
        print('Data retrieved successfully.');
      }
    } else {
      print('No data available.');
    }
  }

}

