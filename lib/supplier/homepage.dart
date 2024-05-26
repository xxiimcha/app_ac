import 'package:flutter/material.dart';
import '../utils/custom_styles.dart';

class SupplierHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AquaConvenience', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              color: Colors.grey[300],
              height: 200,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Photo of WS1',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Water Station 1', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Location (Address)', style: TextStyle(fontSize: 16, color: Colors.black)),
                  Text('Contact Number', style: TextStyle(fontSize: 16, color: Colors.black)),
                  Text('Working Hours', style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: CustomStyles.buttonStyle(),
              onPressed: () {
                // Handle Edit Details
              },
              child: Text('Edit Details'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: CustomStyles.buttonStyle(),
              onPressed: () {
                // Handle Customer Orders
              },
              child: Text('Customer Orders'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: CustomStyles.buttonStyle(),
              onPressed: () {
                // Handle Order History
              },
              child: Text('Order History'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: CustomStyles.buttonStyle(),
              onPressed: () {
                // Handle Delivery Riders
              },
              child: Text('Delivery Riders'),
            ),
          ],
        ),
      ),
    );
  }
}
