import 'package:chef_lens/utilities/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/recipe_details.dart';
import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String imageName;
  final String title;
  final String instructions;
  final List<String> ingredients;

  const ImageButton({
    Key? key,
    required this.imageName,
    required this.title,
    required this.instructions,
    required this.ingredients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle button click
        print("Image button clicked: $title");

        // Navigate to RecipeDetailsPage with the relevant information
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(
              imageName: imageName,
              title: title,
              instructions: instructions,
              ingredients: ingredients,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.watch<AppSettings>().appThemeColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageName,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                // Navigate to RecipeDetailsPage with the relevant information
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(
                      imageName: imageName,
                      title: title,
                      instructions: instructions,
                      ingredients: ingredients,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary:
                    context.watch<AppSettings>().appThemeColor.withOpacity(0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'More...',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
