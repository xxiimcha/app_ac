import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';
import 'connection/database_helper.dart';

class SupplierRegistrationPage extends StatefulWidget {
  @override
  _SupplierRegistrationPageState createState() => _SupplierRegistrationPageState();
}

class _SupplierRegistrationPageState extends State<SupplierRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _stationController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  String? _selectedBarangay;
  final List<String> _barangayList = ['Barangay 1', 'Barangay 2', 'Barangay 3', 'Barangay 4'];
  
  final _imagePicker = ImagePicker();
  XFile? _imageFile;

  Future<void> _selectBusinessPermitImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _insertSupplierData() async {
    MySqlConnection? connection;
    try {
      connection = await DatabaseHelper.getConnection();
      await connection.transaction((transaction) async {
        // Save Valid ID image
        String validIdPath = 'lib/ids/${DateTime.now().millisecondsSinceEpoch}.jpg'; // Define path
        await _imageFile?.saveTo(validIdPath); // Save image
        
        // Save Business Permit image
        String businessPermitPath = 'lib/permits/${DateTime.now().millisecondsSinceEpoch}.jpg'; // Define path
        await _imageFile?.saveTo(businessPermitPath); // Save image

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
      appBar: AppBar(title: Text('Supplier Registration')),
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
                    controller: _stationController,
                    decoration: InputDecoration(labelText: 'Water Station Name'),
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
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _selectImage,
                        child: Column(
                          children: [
                            Text(
                              'Valid ID',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _selectImage,
                              child: Text('Upload Photo'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20), // Add some spacing between the two image pickers
                      GestureDetector(
                        onTap: _selectBusinessPermitImage, // Add a function for selecting business permit image
                        child: Column(
                          children: [
                            Text(
                              'Business Permit',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _selectBusinessPermitImage, // Add a function for selecting business permit image
                              child: Text('Upload Photo'),
                            ),
                          ],
                        ),
                      ),
                    ],
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
