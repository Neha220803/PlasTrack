import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

late Location location;
bool _serviceEnabled = false;
PermissionStatus? _permissionGranted;
LocationData? _locationData;

Future<void> checkLocationPermission() async {
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
  // setState(() {});
}

Future<void> saveLocationToFirestore(double latitude, double longitude) async {
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
