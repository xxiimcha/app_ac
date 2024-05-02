import 'package:flutter/material.dart';
import 'navigation.dart'; // Import the common layout

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConsumerLayout(
      username: 'John Doe', // Pass the username to the common layout
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account Settings'),
        ),
        body: Center(
          child: Text(
            'Account Settings Screen',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
