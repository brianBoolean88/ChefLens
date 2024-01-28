import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../utilities/global.dart' as globals;
import '../widgets/clickable_image.dart';
import './new_recipe_screen.dart';
import './info_screen.dart';
import '../utilities/app_settings.dart';
import '../utilities/global.dart';
import '../widgets/recipe_list.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(107, 71, 71, 71),
                borderRadius: BorderRadius.circular(11.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the Row horizontally
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Welcome,",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              globals.username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: context.watch<AppSettings>().appThemeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NewRecipeScreen()),
                            );
                          },
                          elevation: 2.0,
                          fillColor: context.watch<AppSettings>().appThemeColor,
                          shape: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.auto_awesome_outlined,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "New Recipe",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const InfoScreen()),
                            );
                          },
                          elevation: 2.0,
                          fillColor: context.watch<AppSettings>().appThemeColor,
                          shape: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "Info",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  )
                  
                  
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),

            const Text(
              "Recent Recipes",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const Padding(padding: EdgeInsets.all(10)),

            
            RecipeList(),
            
          ],
        ),
      ),
    );
  }
}