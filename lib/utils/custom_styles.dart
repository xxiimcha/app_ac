import 'package:flutter/material.dart';

class CustomStyles {
  static ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      minimumSize: Size(double.infinity, 50), // Make buttons full width
      textStyle: TextStyle(fontSize: 18),
      padding: EdgeInsets.symmetric(vertical: 10),
    );
  }

  static InputDecoration textBoxDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.blue),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.0),
      ),
      border: OutlineInputBorder(),
    );
  }
}
