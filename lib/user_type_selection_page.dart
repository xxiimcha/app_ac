import 'package:flutter/material.dart';

class UserTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center( // Ensures horizontal centering
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Ensures vertical centering
          crossAxisAlignment: CrossAxisAlignment.center, // Centers the buttons horizontally
          children: <Widget>[
            ElevatedButton(
              child: Text('Consumer'),
              onPressed: () {
                Navigator.pushNamed(context, '/register_consumer');
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Supplier'),
              onPressed: () {
                Navigator.pushNamed(context, '/register_supplier');
              },
            ),
          ],
        ),
      ),
    );
  }
}
