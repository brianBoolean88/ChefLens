import 'package:flutter/material.dart';
import '../utilities/global.dart';
import '../screens/notification_page.dart';
import '../screens/home_page.dart';

class NewRecipeScreen extends StatefulWidget {
  const NewRecipeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewRecipeScreenState createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _recipeDescriptionController =
      TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();

  List<String> ingredientList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Recipe Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recipe Name:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _recipeNameController,
              decoration: const InputDecoration(
                hintText: "Enter recipe name",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Recipe Description:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _recipeDescriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter recipe description",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Ingredient List:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    decoration: const InputDecoration(
                      hintText: "Enter an ingredient",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      final ingredient = _ingredientController.text.trim();
                      if (ingredient.isNotEmpty) {
                        ingredientList.add(ingredient);
                        _ingredientController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Ingredients: ${ingredientList.join(', ')}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Check if all fields have text before saving
                if (_recipeNameController.text.isNotEmpty &&
                    _recipeDescriptionController.text.isNotEmpty &&
                    ingredientList.isNotEmpty) {
                  // Save the recipe with the entered data
                  final recipeName = _recipeNameController.text;
                  final recipeDescription = _recipeDescriptionController.text;

                  // Combine all recipe information into a list
                  List<String> recipeInfo = [recipeName, recipeDescription, ...ingredientList];

                  // Save the recipe to the global list
                  
                  userRecipes.add(recipeInfo);
                  print("printing user recipes");
                  print(userRecipes);
                  // Navigate to the NotificationPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(
                        textNotification: "Recipe saved successfully!",
                        color: Colors.green,
                      ),
                    ),
                  );
                } else {
                  // Show an error message or handle accordingly
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Error"),
                      content: const Text("Please fill in all fields."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text("Save Recipe"),
            ),

          ]
        ),
      ),
    );
  }
}
