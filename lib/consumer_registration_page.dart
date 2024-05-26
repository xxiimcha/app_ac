import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'connection/database_helper.dart';
import 'utils/custom_styles.dart'; // Import the custom styles

class ConsumerRegistrationPage extends StatefulWidget {
  @override
  _ConsumerRegistrationPageState createState() => _ConsumerRegistrationPageState();
}

class _ConsumerRegistrationPageState extends State<ConsumerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  String? _selectedBarangay;
  final List<String> _barangayList = ['Barangay 1', 'Barangay 2', 'Barangay 3', 'Barangay 4'];

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0]; // Formatting the date
      });
    }
  }

  Future<void> _insertCustomerData() async {
    MySqlConnection? connection;
    try {
      connection = await DatabaseHelper.getConnection();
      await connection.transaction((transaction) async {
        Results result = await transaction.query('''
          INSERT INTO customers (firstname, middlename, lastname, birthdate, address, contact_number, barangay, username, email, password)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          _firstNameController.text,
          _middleNameController.text,
          _lastNameController.text,
          _dateController.text,
          _addressController.text,
          _contactController.text,
          _selectedBarangay,
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        ]);

        int customerId = result.insertId!;

        await transaction.query('''
          INSERT INTO users (name, username, password, user_type, customer_id)
          VALUES (?, ?, ?, ?, ?)
        ''', [
          '${_firstNameController.text} ${_lastNameController.text}',
          _usernameController.text,
          _passwordController.text,
          1,
          customerId,
        ]);
      });
      print('Customer data inserted successfully');
      print('User data inserted successfully');
    } catch (e) {
      print('Error inserting data: $e');
    } finally {
      if (connection != null) {
        await connection.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consumer Registration')),
      body: Center(
        child: SingleChildScrollView( // Allows for scrolling when needed
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _firstNameController,
                    decoration: CustomStyles.textBoxDecoration('First Name'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _middleNameController,
                    decoration: CustomStyles.textBoxDecoration('Middle Name'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: CustomStyles.textBoxDecoration('Last Name'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _dateController,
                    decoration: CustomStyles.textBoxDecoration('Date of Birth'),
                    readOnly: true, // Prevents keyboard from appearing
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: CustomStyles.textBoxDecoration('Address'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _contactController,
                    decoration: CustomStyles.textBoxDecoration('Contact Number'),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedBarangay,
                    decoration: CustomStyles.textBoxDecoration('Barangay'),
                    items: _barangayList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBarangay = newValue;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a barangay';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _usernameController,
                    decoration: CustomStyles.textBoxDecoration('Username'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: CustomStyles.textBoxDecoration('Email'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: CustomStyles.textBoxDecoration('Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmController,
                    decoration: CustomStyles.textBoxDecoration('Confirm Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: CustomStyles.buttonStyle(),
                    child: Text('Register'),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _insertCustomerData();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
