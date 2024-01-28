import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String imageName;
  final String title;

  const ImageButton({super.key, required this.imageName, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle button click
        print("Image button clicked: $imageName");
      },
      child: Container(
        width: 150, // Adjust the width as needed
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color.fromARGB(107, 71, 71, 71),
          borderRadius: BorderRadius.circular(11.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageName,
              width: 80, // Adjust the image width as needed
              height: 80, // Adjust the image height as needed
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
