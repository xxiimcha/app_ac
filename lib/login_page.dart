import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'connection/database_helper.dart';
import 'consumer/homepage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Log In')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 10), // Adds space between the text fields
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true, // Obscures the text input for passwords
              ),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Add forgot password logic
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Log In'),
                onPressed: () async {
                  MySqlConnection? connection;
                  try {
                    connection = await DatabaseHelper.getConnection();
                    var result = await connection.query(
                        'SELECT * FROM users WHERE username = ? AND password = ?',
                        [usernameController.text, passwordController.text]);

                    if (result.isNotEmpty) {
                      var userRow = result.first;

                      if (userRow['user_type'] == 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ConsumerHomePage()),
                        );
                      } else {
                      }
                    } else {
                      print('Invalid username or password');
                    }
                  } catch (e) {
                    print('Error: $e');
                  } finally {
                    if (connection != null) {
                      await connection.close();
                    }
                  }
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("Don't have an account? Sign up"),
                onPressed: () {
                  Navigator.pushNamed(context, '/user_type');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
