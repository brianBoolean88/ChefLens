import 'package:chef_lens/utilities/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/global.dart';

class CurrentRecipesPage extends StatelessWidget {
  const CurrentRecipesPage({super.key});

  void _removeRecipe(BuildContext context, int index) {
    // Assuming userRecipes is a global List<List<String>> containing the recipes
    if (index >= 0 && index < userRecipes.length) {
      // Remove the recipe from the global list
      userRecipes.removeAt(index);

      // Show a snackbar to indicate successful removal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recipe removed successfully'),
        ),
      );

      Provider.of<AppSettings>(context, listen: false)
          .reload(); // Replace with your appropriate reload method

      // You may also navigate to another screen or perform any other actions as needed
    } else {
      // Handle the case when the index is out of bounds
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid index for recipe removal'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Saved Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userRecipes.isEmpty
            ? const Center(
                child: Text(
                  'No recipes',
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.42)),
                ),
              )
            : ListView.builder(
                itemCount: userRecipes.length,
                itemBuilder: (context, index) {
                  List<String> recipeInfo = userRecipes[index];

                  // Assuming the recipe info format is [name, description, ingredient1, ingredient2, ...]
                  String recipeName = recipeInfo[0];
                  String recipeDescription = recipeInfo[1];
                  List<String> ingredients = recipeInfo.sublist(2);

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        recipeName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipeDescription),
                          const SizedBox(height: 8),
                          Text("Ingredients: ${ingredients.join(', ')}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Call the remove function when the remove button is clicked
                          _removeRecipe(context, index);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
