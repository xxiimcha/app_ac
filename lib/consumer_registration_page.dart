import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'connection/database_helper.dart';

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
  TextEditingController _barangayController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  // Additional controllers as needed
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

  String? _selectedBarangay;
  final List<String> _barangayList = ['Barangay 1', 'Barangay 2', 'Barangay 3', 'Barangay 4'];

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
          _firstNameController.text,
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
                    decoration: InputDecoration(labelText: 'First Name'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _middleNameController,
                    decoration: InputDecoration(labelText: 'MIddle Name'),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Date of Birth'),
                    readOnly: true, // Prevents keyboard from appearing
                    onTap: () => _selectDate(context),
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                  ),
                  TextFormField(
                    controller: _contactController,
                    decoration: InputDecoration(labelText: 'Contact Number'),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedBarangay,
                    decoration: InputDecoration(labelText: 'Barangay'),
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
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  TextFormField(
                    controller: _confirmController,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
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
