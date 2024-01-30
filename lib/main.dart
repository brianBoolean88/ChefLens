import 'package:flutter/material.dart';
import './utilities/customscroll.dart';
import 'screens/root_page.dart';
import './utilities/app_settings.dart';
import 'package:provider/provider.dart';
import './utilities/global.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "XXX",
      appId: "XXX",
      messagingSenderId: "XXX",
      projectId: "XXX",
    ),
  );
  initializeGlobals();

  AppSettings userSettings = AppSettings();
  userSettings.initializeColorGlobal();

  runApp(
    ChangeNotifierProvider(
      create: (context) => userSettings,
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
