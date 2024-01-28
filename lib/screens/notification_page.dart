// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final String textNotification;
  final Color color;

  const NotificationPage({Key? key, required this.textNotification, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Use popUntil to go back two screens
        Navigator.popUntil(context, ModalRoute.withName('/'));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
        ),
        body: Center(
          child: Text(
            textNotification,
            style: TextStyle(color: color),
          ),
        ),
      ),
    );
  }
}
