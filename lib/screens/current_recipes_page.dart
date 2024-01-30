import 'package:chef_lens/utilities/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/global.dart';
import 'package:firebase_database/firebase_database.dart';

class CurrentRecipesPage extends StatelessWidget {
  const CurrentRecipesPage({super.key});

  void _removeRecipe(BuildContext context, int index) async {
    if (index >= 0 && index < userRecipes.length) {
      userRecipes.removeAt(index);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe removed successfully'),
        ),
      );

      Provider.of<AppSettings>(context, listen: false).reload();

      //DATA SET
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");
      await ref.update({
        "userRecipes": userRecipes,
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _removeRecipe(context, index);
                          Navigator.pop(context);
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
