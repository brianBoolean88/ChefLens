import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChefLens - Info Screen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to ChefLens!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Our team is designing an app called ChefLens for the 2023-2024 year. "
                "This helpful tool utilizes AI detection algorithms in photos to provide "
                "recipes and nutritional values based on your available ingredients.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/icon.png', // Replace with the actual image path
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "ChefLens - A Free and Accessible Service",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "ChefLens is unique as it offers its services completely free of charge. "
                "No features will be locked behind paywalls. Funding for the project "
                "will likely come from advertisements or sponsorships from companies.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Providing Accessible Nutrition Tracking",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Other nutrition tracking apps often have subscription services, making "
                "the user experience complicated. ChefLens, on the other hand, provides "
                "all services for free, making it more accessible for users of all ages.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "User-Friendly Interface and Advanced AI",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "ChefLens offers an easy-to-use UI and a streamlined navigational experience. "
                "Our app utilizes advanced AI, which is also free for users. Unlike other AI apps, "
                "ChefLens provides immediate access to its most accurate AI model without any paywalls.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
