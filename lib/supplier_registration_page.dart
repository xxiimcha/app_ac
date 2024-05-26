import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';
import 'connection/database_helper.dart';
import 'utils/custom_styles.dart'; // Import the custom styles

class SupplierRegistrationPage extends StatefulWidget {
  @override
  _SupplierRegistrationPageState createState() => _SupplierRegistrationPageState();
}

class _SupplierRegistrationPageState extends State<SupplierRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String? _selectedBarangay;
  final List<String> _barangayList = ['Barangay 1', 'Barangay 2', 'Barangay 3', 'Barangay 4'];

  final _imagePicker = ImagePicker();
  XFile? _validIdImageFile;
  XFile? _businessPermitImageFile;

  Future<void> _selectImage(bool isValidId) async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isValidId) {
          _validIdImageFile = pickedFile;
        } else {
          _businessPermitImageFile = pickedFile;
        }
      });
    }
  }

  Future<void> _insertSupplierData() async {
    MySqlConnection? connection;
    try {
      connection = await DatabaseHelper.getConnection();
      await connection.transaction((transaction) async {
        // Save Valid ID image
        String validIdPath = 'lib/ids/${DateTime.now().millisecondsSinceEpoch}_valid_id.jpg'; // Define path
        await _validIdImageFile?.saveTo(validIdPath); // Save image

        // Save Business Permit image
        String businessPermitPath = 'lib/permits/${DateTime.now().millisecondsSinceEpoch}_business_permit.jpg'; // Define path
        await _businessPermitImageFile?.saveTo(businessPermitPath); // Save image

        // Insert supplier data into database
        Results result = await transaction.query('''
          INSERT INTO suppliers (first_name, middle_name, last_name, water_station_name, address, contact_number, barangay, valid_id_path, business_permit_path, username, email, password)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          _firstNameController.text,
          _middleNameController.text,
          _lastNameController.text,
          _stationController.text,
          _addressController.text,
          _contactController.text,
          _selectedBarangay,
          validIdPath, // Insert Valid ID path
          businessPermitPath, // Insert Business Permit path
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        ]);

        int supplierId = result.insertId!;

        // Insert into users table
        await transaction.query('''
          INSERT INTO users (name, username, password, user_type, supplier_id)
          VALUES (?, ?, ?, ?, ?)
        ''', [
          '${_firstNameController.text} ${_lastNameController.text}',
          _usernameController.text,
          _passwordController.text,
          2, // Assuming 2 represents supplier user type
          supplierId,
        ]);
      });
      print('Supplier data inserted successfully');
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
      appBar: AppBar(
        title: Text('Supplier Registration'),
        backgroundColor: Colors.blue, // Set AppBar color to blue
      ),
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
                    controller: _stationController,
                    decoration: CustomStyles.textBoxDecoration('Water Station Name'),
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
                  SizedBox(height: 20),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => _selectImage(true),
                        child: Column(
                          children: [
                            Text(
                              'Valid ID',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: CustomStyles.buttonStyle().copyWith(
                                minimumSize: MaterialStateProperty.all(Size(200, 50)),
                              ),
                              onPressed: () => _selectImage(true),
                              child: Text('Upload Photo'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20), // Add some spacing between the two image pickers
                      GestureDetector(
                        onTap: () => _selectImage(false),
                        child: Column(
                          children: [
                            Text(
                              'Business Permit',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: CustomStyles.buttonStyle().copyWith(
                                minimumSize: MaterialStateProperty.all(Size(200, 50)),
                              ),
                              onPressed: () => _selectImage(false),
                              child: Text('Upload Photo'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                    decoration: CustomStyles.textBoxDecoration('Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmController,
                    decoration: CustomStyles.textBoxDecoration('Confirm Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: CustomStyles.buttonStyle(),
                    child: Text('Register'),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await _insertSupplierData();
                        Navigator.pop(context); // Navigate back to the login page
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
