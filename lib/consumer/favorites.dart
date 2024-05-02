import 'package:flutter/material.dart';
import 'navigation.dart'; // Import the common layout

class MyFavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConsumerLayout(
      username: 'John Doe', // Pass the username to the common layout
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Favorites'),
        ),
        body: Center(
          child: Text(
            'My Favorites Screen',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
