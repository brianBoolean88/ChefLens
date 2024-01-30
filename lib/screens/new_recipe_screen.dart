import 'package:flutter/material.dart';
import '../utilities/global.dart';
import '../screens/notification_page.dart';
import 'package:firebase_database/firebase_database.dart';

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
              onPressed: () async {
                if (_recipeNameController.text.isNotEmpty &&
                    _recipeDescriptionController.text.isNotEmpty &&
                    ingredientList.isNotEmpty) {
                  final recipeName = _recipeNameController.text;
                  final recipeDescription = _recipeDescriptionController.text;

                  List<String> recipeInfo = [recipeName, recipeDescription, ...ingredientList];
                  
                  userRecipes.add(recipeInfo);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(
                        textNotification: "Recipe saved successfully!",
                        color: Colors.green,
                      ),
                    ),
                  );

                  //DATA SET
                  DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");
                  await ref.update({
                    "userRecipes": ingredientList,
                  });
                  
                } else {
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
