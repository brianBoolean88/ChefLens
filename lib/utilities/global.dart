library my_prj.globals;

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

String username = "Example User";
List<List<String>> userRecipes = [];
IconData selectedIcon = Icons.account_circle;

//DATA GET
void initializeGlobals() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users/123');

  DataSnapshot snapshot = await ref.get();
  if (snapshot.exists) {
    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      username = data['username'] ?? "Example User";
      userRecipes = data['userRecipes'];
      selectedIcon = data['profileIcon'];
      print('Data retrieved successfully.');
    }
  } else {

    await ref.set({
      "username": username,
      "userRecipes": userRecipes,
      "profileIcon": selectedIcon,
      "appThemeColor": const Color.fromARGB(255, 233, 117, 63),
    }); 

  }
}