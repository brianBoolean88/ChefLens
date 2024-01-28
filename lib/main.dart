import "package:flutter/material.dart";
import './utilities/customscroll.dart';
import "screens/root_page.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chef Lens",
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 233, 117, 63),
          brightness: Brightness.dark,
        ),
        fontFamily: "Poppins",
      ),
      home: const RootPage(),
    );
  }
}
