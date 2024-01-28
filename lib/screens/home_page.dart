import "package:flutter/material.dart";
import '../utilities/global.dart' as globals;
import '../widgets/clickable_image.dart';

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
                color: Color.fromARGB(107, 71, 71, 71),
                borderRadius: BorderRadius.circular(11.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromRGBO(255, 176, 85, 1),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RawMaterialButton(
                      onPressed: () => print("hi"),
                      elevation: 2.0,
                      fillColor: const Color.fromARGB(255, 233, 117, 63),
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
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            const SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ImageButton(imageName: "assets/images/icon.png", title: "New Test 1"),
                    ImageButton(imageName: "assets/images/icon.png", title: "New Test 2"),
                    ImageButton(imageName: "assets/images/icon.png", title: "New Test 3"),
                    ImageButton(imageName: "assets/images/icon.png", title: "New Test 4"),
                    ImageButton(imageName: "assets/images/icon.png", title: "New Test 5"),
                    ImageButton(imageName: "assets/images/icon.png", title: "New Test 6"),
                    ImageButton(imageName: "assets/images/icon.png", title: "New Test 7"),
                    // Add more image buttons as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
