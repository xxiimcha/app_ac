import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Ensure correct LatLng import
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../provider/user_provider.dart'; // Import the UserProvider
import 'navigation.dart'; // Assuming ConsumerLayout is here

class ConsumerHomePage extends StatefulWidget {
  @override
  _ConsumerHomePageState createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentPosition!, 15.0); // Set initial position and zoom level
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    
    // Check if the user is null before using its properties
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }

    return ConsumerLayout(
      username: user.username, // Ensure user is not null before accessing username
      child: Scaffold(
        body: Center(
          child: _currentPosition == null
              ? CircularProgressIndicator() // Show a loading indicator until the location is fetched
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _currentPosition,
                    zoom: 15.0,
                    onTap: (tapPosition, point) {
                      print("Latitude: ${point.latitude}");
                      print("Longitude: ${point.longitude}");
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _currentPosition!,
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
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
