import 'package:flutter/material.dart';
import 'utils/custom_styles.dart'; // Import the custom styles

class UserTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.blue, // Set AppBar color to blue
      ),
      body: Center( // Ensures horizontal centering
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Adds padding around the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Ensures vertical centering
            crossAxisAlignment: CrossAxisAlignment.center, // Centers the buttons horizontally
            children: <Widget>[
              ElevatedButton(
                style: CustomStyles.buttonStyle(),
                child: Text('Consumer'),
                onPressed: () {
                  Navigator.pushNamed(context, '/register_consumer');
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: CustomStyles.buttonStyle(),
                child: Text('Supplier'),
                onPressed: () {
                  Navigator.pushNamed(context, '/register_supplier');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
