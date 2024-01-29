import 'package:flutter/material.dart';
import '../utilities/global.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    int numberOfSavedRecipes = userRecipes.length;

    String userLevel = _getUserLevel(numberOfSavedRecipes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfilePicture(),
              const SizedBox(height: 20),
              Text(
                'Username: $username',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Number of Saved Recipes: $numberOfSavedRecipes',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'User Level: $userLevel',
                style: const TextStyle(fontSize: 16),
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
    if (numberOfSavedRecipes >= 25) {
      return 'Master';
    } else if (numberOfSavedRecipes >= 20) {
      return 'Senior';
    } else if (numberOfSavedRecipes >= 15) {
      return 'Expert';
    } else if (numberOfSavedRecipes >= 10) {
      return 'Advanced';
    } else if (numberOfSavedRecipes >= 5) {
      return 'Intermediate';
    } else {
      return 'Novice';
    }
  }
}
