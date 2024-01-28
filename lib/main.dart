import 'package:flutter/material.dart';
import './utilities/customscroll.dart';
import 'screens/root_page.dart';
import './utilities/app_settings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppSettings(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chef Lens",
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: context.watch<AppSettings>().appThemeColor,
          brightness: Brightness.dark,
        ),
        fontFamily: "Poppins",
      ),
      home: const RootPage(),
    );
  }
}
