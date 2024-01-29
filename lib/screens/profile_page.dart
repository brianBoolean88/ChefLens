import 'package:flutter/material.dart';
import '../utilities/global.dart';
import '../utilities/app_settings.dart';
import 'package:provider/provider.dart';
import '../screens/home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the username and number of saved recipes from globals.dart
    int numberOfSavedRecipes = userRecipes.length;

    // Determine the user's level based on the number of saved recipes
    String userLevel = _getUserLevel(numberOfSavedRecipes);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display the profile picture (using Flutter Icons)
              _buildProfilePicture(),
              const SizedBox(height: 20),
              // Display the username
              Text(
                'Username: $username',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Display the number of saved recipes
              Text(
                'Number of Saved Recipes: $numberOfSavedRecipes',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              // Display the user level
              Text(
                'User Level: $userLevel',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Icon(
      selectedIcon,
      size: 100,
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
  }

  String _getUserLevel(int numberOfSavedRecipes) {
    // Determine the user level based on the number of saved recipes
    if (numberOfSavedRecipes > 20) {
      return 'Expert';
    } else if (numberOfSavedRecipes > 10) {
      return 'Advanced';
    } else {
      return 'Novice';
    }
  }
}
