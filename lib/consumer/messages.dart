import 'package:flutter/material.dart';
import 'navigation.dart'; // Import the common layout

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConsumerLayout(
      username: 'John Doe', // Pass the username to the common layout
      child: Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
        ),
        body: Center(
          child: Text(
            'Messages Screen',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
