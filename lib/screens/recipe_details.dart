import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final String imageName;
  final String title;
  final String instructions;
  final List<String> ingredients;

  const RecipeDetailsPage({
    Key? key,
    required this.imageName,
    required this.title,
    required this.instructions,
    required this.ingredients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              imageName,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ingredients
                        .map((ingredient) => Text('- $ingredient'))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(instructions),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
