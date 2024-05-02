import 'package:flutter/material.dart';
import 'navigation.dart'; // Import the common layout

class ConsumerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConsumerLayout(
      username: 'John Doe', // Pass the username to the common layout
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Consumer Homepage!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle logout
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
