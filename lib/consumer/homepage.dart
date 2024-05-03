import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'navigation.dart'; // Assuming ConsumerLayout is here

class ConsumerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConsumerLayout(
      username: 'John Doe',
      child: Scaffold(
        body: Center(
          child: OpenStreetMapSearchAndPick(
            buttonTextStyle: const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
            buttonColor: Colors.blue,
            onPicked: (pickedData) {
              try {
                print("Latitude: ${pickedData.latLong.latitude}");
                print("Longitude: ${pickedData.latLong.longitude}");
                print("Address: ${pickedData.address}");
                print("Address Name: ${pickedData.addressName}");
              } catch (e) {
                print("Error processing picked data: $e");
              }
            },
          ),
        ),
      ),
    );
  }
}
