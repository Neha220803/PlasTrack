// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonatePlasticPage extends StatefulWidget {
  const DonatePlasticPage({Key? key}) : super(key: key);

  @override
  State<DonatePlasticPage> createState() => _DonatePlasticPageState();
}

class _DonatePlasticPageState extends State<DonatePlasticPage> {
  late Location location;
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  bool _loading = false; // Add a loading state variable

  @override
  void initState() {
    super.initState();
    location = Location();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {});
  }

  Future<void> _saveLocationToFirestore(
      double latitude, double longitude) async {
    try {
      CollectionReference locationCollection =
          FirebaseFirestore.instance.collection('location');

      // Add a new document to the collection with the specified ID
      await locationCollection.add({
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime
            .now(), // Add a timestamp field to record the time of the donation
      });

      print('Location data added to Firestore successfully!');
    } catch (e) {
      print('Error adding location data to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "images/flag.png",
            height: 150,
          ),
          const SizedBox(height: 20),
          const Text(
            "Do you want your plastic to be collected?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Stack(alignment: Alignment.center, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                fixedSize: const Size(300, 50),
              ),
              onPressed: () async {
                setState(() {
                  _loading = true; // Set loading to true when button is pressed
                });

                // Get the current location
                LocationData? locationData = await location.getLocation();
                double latitude = locationData.latitude!;
                double longitude = locationData.longitude!;

                // Save location data to Firestore
                await _saveLocationToFirestore(latitude, longitude);

                setState(() {
                  _loading = false; // Set loading to false after data is saved
                });

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _loading
                                    ? CircularProgressIndicator() // Show circular progress indicator when loading
                                    : Image.asset('images/success.png',
                                        height: 150),
                                const SizedBox(height: 20),
                                Text(
                                  "Successful!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  "Thank You for Your Contribution!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Text(
                                    "Your response has been noted for the recycling program. You will receive the appropriate reward when the order reaches the warehouse.\n\nLatitude: $latitude\nLongitude: $longitude",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: const Text("Yes, Flag my location"),
            ),
          ]),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
