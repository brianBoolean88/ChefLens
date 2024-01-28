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
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...getRecentRecipes().map(
              (recipe) => ImageButton(
                imageName: recipe[0], // Assuming the first element is the image name
                title: recipe[1], // Assuming the second element is the title
              ),
            ),
            const ImageButton(imageName: "assets/images/icon.png", title: "New Test 1"),
            const ImageButton(imageName: "assets/images/icon.png", title: "New Test 2"),
            const ImageButton(imageName: "assets/images/icon.png", title: "New Test 3"),
            const ImageButton(imageName: "assets/images/icon.png", title: "New Test 4"),
            const ImageButton(imageName: "assets/images/icon.png", title: "New Test 5"),
            const ImageButton(imageName: "assets/images/icon.png", title: "New Test 6"),
            const ImageButton(imageName: "assets/images/icon.png", title: "New Test 7"),
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
