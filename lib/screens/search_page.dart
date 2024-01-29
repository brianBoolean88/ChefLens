import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/clickable_image.dart';
import '../widgets/custom_progress_indicator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchRecipes(String keyword) async {
    if (keyword.isNotEmpty) {
      try {
        setState(() {
          _isLoading = true;
        });

        final response = await http.get(Uri.parse(
            'https://www.themealdb.com/api/json/v1/1/search.php?s=$keyword'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          List<dynamic> meals = data['meals'];
          // ignore: unnecessary_null_comparison
          if (meals != null) {
            setState(() {
              _searchResults = List<Map<String, dynamic>>.from(meals);
            });
          }
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Internet issues....'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nothing found...'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid recipe'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for a recipe...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String keyword = _searchController.text;
                _searchRecipes(keyword);
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CustomProgressIndicator(
                subwidget: Text('Loading...'),
              )
            else
              _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final recipe = _searchResults[index];
          return ImageButton(
            imageName: recipe['strMealThumb'],
            title: recipe['strMeal'],
            instructions: List.generate(20, (index) {
              final instruction = recipe['strInstructions'];
              return '$instruction';
            })
                .where((instruction) => instruction.trim().isNotEmpty)
                .toList()
                .first,
            ingredients: List.generate(20, (index) {
              final ingredient = recipe['strIngredient${index + 1}'];
              final measure = recipe['strMeasure${index + 1}'];
              return '$measure $ingredient';
            }).where((ingredient) => ingredient.trim().isNotEmpty).toList(),
          );
        },
      ),
    );
  }
}
