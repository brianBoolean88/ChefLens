import "package:flutter/material.dart";
import "package:intl/intl.dart";

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).colorScheme;

    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat("yMd").format(currentDate);

    return AppBar(
      backgroundColor: appColorScheme.primaryContainer,
      leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage("assets/images/icon.png"))),
      title: Text(
        "Chef Lens",
        style: TextStyle(
          color: appColorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            formattedDate,
            style: TextStyle(
              color: appColorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
