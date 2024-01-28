import 'package:flutter/material.dart';
import '../screens/settings_page.dart';
import '../screens/current_recipes_page.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: appColorScheme.primaryContainer,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Image(image: AssetImage("assets/images/icon.png")),
      ),
      title: Text(
        "Chef Lens",
        style: TextStyle(
          color: appColorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              } else if (value == 'recipes') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CurrentRecipesPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8.0),
                      Text('Settings'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'recipes',
                  child: Row(
                    children: [
                      Icon(Icons.insert_chart_sharp),
                      SizedBox(width: 8.0),
                      Text('Recipes'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }
}
