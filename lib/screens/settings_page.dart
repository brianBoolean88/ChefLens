import 'package:flutter/material.dart';
import '../utilities/global.dart';
import '../utilities/app_settings.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _usernameController;
  Color _selectedColor = Colors.blue; // Default color

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Username:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter new username',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Change App Theme Color:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildColorButton(Colors.blue),
                _buildColorButton(const Color.fromARGB(255, 233, 117, 63)),
                _buildColorButton(Colors.green),
                _buildColorButton(Colors.yellow),
                _buildColorButton(Colors.red),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save the changes
                String newUsername = _usernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  // Update the global username
                  Provider.of<AppSettings>(context, listen: false).appThemeColor = _selectedColor;
                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Settings saved successfully'),
                    ),
                  );
                } else {
                  // Show an error message for an empty username
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid username'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Save Settings'),
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
        margin: EdgeInsets.all(8),
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
}
