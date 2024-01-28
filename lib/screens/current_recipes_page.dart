import 'package:flutter/material.dart';
import '../utilities/global.dart';

class CurrentRecipesPage extends StatelessWidget {
  const CurrentRecipesPage({super.key});

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
                    ),
                  );
                },
              ),
      ),
    );
  }
}
