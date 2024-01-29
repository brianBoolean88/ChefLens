import 'package:chef_lens/widgets/clickable_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_progress_indicator.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List _recentRecipes = [];
  bool _isLoading = true;
  bool loadedRecipes = false;

  @override
  void initState() {
    super.initState();
    _fetchRandomRecipes();
  }

  Future<void> _fetchRandomRecipes() async {
    const url = 'https://www.themealdb.com/api/json/v1/1/random.php';

    try {
      setState(() {
        _isLoading = true;
      });

      final responses = await Future.wait(
        List.generate(5, (_) => http.get(Uri.parse(url))),
      );

      final List meals = responses
          .where((response) => response.statusCode == 200)
          .map((response) => json.decode(response.body)['meals'][0])
          .toList();

      setState(() {
        _recentRecipes = meals;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Internet issues....'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CustomProgressIndicator(
            subwidget: Text('Loading Recipes...'),
          )
        : SizedBox(
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
}
