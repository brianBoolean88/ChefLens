import 'package:chef_lens/widgets/clickable_image.dart';
import 'package:flutter/material.dart';
import '../utilities/global.dart';

const int maxRecentRecipes = 3;

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
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
          ],
        ),
      ),
    );
  }

  List<List<String>> getRecentRecipes() {
    int endIndex = userRecipes.length > maxRecentRecipes
        ? maxRecentRecipes
        : userRecipes.length;

    print("getting updates");
    print(userRecipes.sublist(0, endIndex));
    return userRecipes.sublist(0, endIndex);
  }
}
