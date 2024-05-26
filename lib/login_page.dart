import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'connection/database_helper.dart';
import 'consumer/homepage.dart';
import 'supplier/homepage.dart'; // Ensure you have a SupplierHomePage
import 'utils/custom_styles.dart';
import 'provider/user_provider.dart';
import 'class/user.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: CustomStyles.textBoxDecoration('Username'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: CustomStyles.textBoxDecoration('Password'),
                obscureText: true,
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
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: CustomStyles.buttonStyle(),
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
                      var user = User.fromMap(userRow.fields);

                      // Save the user session
                      Provider.of<UserProvider>(context, listen: false).setUser(user);

                      if (user.userType == 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ConsumerHomePage()),
                        );
                      } else if (user.userType == 2) {
                        var approvalResult = await connection.query(
                          'SELECT is_approved FROM suppliers WHERE user_id = ?',
                          [user.id],
                        );

                        var isApproved = approvalResult.first['is_approved'];

                        if (isApproved == 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SupplierHomePage()),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Your account is pending approval.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
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
                style: CustomStyles.buttonStyle(),
                child: Text("Don't have an account? Sign up"),
                onPressed: () {
                  Navigator.pushNamed(context, '/user_type');
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: CustomStyles.buttonStyle().copyWith(
                      minimumSize: MaterialStateProperty.all(Size(150, 50)),
                    ),
                    child: Text('Google'),
                    onPressed: () {
                      // Handle Google login
                    },
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: CustomStyles.buttonStyle().copyWith(
                      minimumSize: MaterialStateProperty.all(Size(150, 50)),
                    ),
                    child: Text('Facebook'),
                    onPressed: () {
                      // Handle Facebook login
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
