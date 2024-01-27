import "package:flutter/material.dart";

import "../widgets/scrollable_news_container.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [Text("ChefLens")],
          ),
          ElevatedButton(
            child: const Text("Search"),
            onPressed: () => {print("hi")},
          ),
        ],
      ),
    );
  }
}
