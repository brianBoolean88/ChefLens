import 'package:chef_lens/widgets/clickable_image.dart';
import 'package:flutter/material.dart';
import '../utilities/global.dart';
import 'package:http/http.dart' as http;
import '../widgets/clickable_image.dart';
import 'dart:convert';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List _recentRecipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRandomRecipes();
  }

  Future<void> _fetchRandomRecipes() async {
    final url = 'https://www.themealdb.com/api/json/v1/1/random.php';

    try {
      // Fetch 5 random meals
      final responses = await Future.wait(
        List.generate(5, (_) => http.get(Uri.parse(url))),
      );

      // Parse each response and store in _recentRecipes
      final List meals = responses
          .where((response) => response.statusCode == 200)
          .map((response) => json.decode(response.body)['meals'][0])
          .toList();

      setState(() {
        _recentRecipes = meals;
      });
    } catch (e) {
      // Handle errors, such as network issues
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _recentRecipes.map((recipe) {
            List<String> ingredients = _getIngredients(recipe);

            return ImageButton(
              imageName: recipe['strMealThumb'],
              title: recipe['strMeal'],
              instructions: recipe['strInstructions'],
              ingredients: ingredients,
            );
          }).toList(),
        ),
      ),
    );
  }
}

List<String> _getIngredients(Map<String, dynamic> recipe) {
  List<String> ingredients = [];
  for (int i = 1; i <= 20; i++) {
    String ingredientKey = 'strIngredient$i';
    if (recipe.containsKey(ingredientKey) &&
        recipe[ingredientKey] != null &&
        recipe[ingredientKey].trim().isNotEmpty) {
      ingredients.add(recipe[ingredientKey]);
    }
  }
  return ingredients;
}
