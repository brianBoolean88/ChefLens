import 'package:flutter/material.dart';
import '../utilities/global.dart';
import '../utilities/app_settings.dart';
import 'package:provider/provider.dart';
import '../screens/home_page.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _usernameController;
  Color _selectedColor = Colors.blue; // Default color
  IconData _selectedIcon = Icons.account_circle; // Default icon

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Username:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter new username',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Change App Theme Color:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildColorButton(Colors.blue),
                _buildColorButton(const Color.fromARGB(255, 233, 117, 63)),
                _buildColorButton(Colors.green),
                _buildColorButton(Colors.yellow),
                _buildColorButton(Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose Profile Icon:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildIconButton(Icons.account_circle),
                _buildIconButton(Icons.supervised_user_circle),
                _buildIconButton(Icons.support_agent_sharp),
                _buildIconButton(Icons.surfing),
                _buildIconButton(Icons.support_sharp),
                _buildIconButton(Icons.tag_faces_outlined),
                _buildIconButton(Icons.tornado_rounded),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String newUsername = _usernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  username = newUsername;
                  Provider.of<AppSettings>(context, listen: false)
                      .appThemeColor = _selectedColor;

                  selectedIcon = _selectedIcon;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved successfully'),
                    ),
                  );

                  HomePage.keyState.currentState?.reload();
                  Navigator.of(context)
                      .pop();

                  //DATA SET
                  DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");
                  await ref.update({
                    "username": username,
                    "appThemeColor": _selectedColor,
                    "profileIcon": _selectedIcon,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid username'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIcon = icon;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedIcon == icon
                ? context.watch<AppSettings>().appThemeColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Icon(icon,
            size: 30, color: context.watch<AppSettings>().appThemeColor),
      ),
    );
  }
}
