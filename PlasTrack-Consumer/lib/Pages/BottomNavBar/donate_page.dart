import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:plas_track/Functions/location_permission.dart';
import 'package:plas_track/Widgets/custom_text.dart';
import 'package:plas_track/Widgets/custome_button.dart';

class DonatePlasticPage extends StatefulWidget {
  const DonatePlasticPage({Key? key}) : super(key: key);

  @override
  State<DonatePlasticPage> createState() => _DonatePlasticPageState();
}

class _DonatePlasticPageState extends State<DonatePlasticPage> {
  late Location location;
  bool _loading = false; // Add a loading state variable

  @override
  void initState() {
    super.initState();
    location = Location();
    checkLocationPermission();
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
            CustomButton(
              text: "Yes, Flag my location",
              fixedSize: const Size(300, 50),
              callback: () async {
                setState(() {
                  _loading = true; // Set loading to true when button is pressed
                });

                // Get the current location
                LocationData? locationData = await location.getLocation();
                double latitude = locationData.latitude!;
                double longitude = locationData.longitude!;

                // Save location data to Firestore
                await saveLocationToFirestore(latitude, longitude);

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
                                    ? const CircularProgressIndicator() // Show circular progress indicator when loading
                                    : Image.asset('images/success.png',
                                        height: 150),
                                const SizedBox(height: 20),
                                const Text(
                                  "Successful!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                const Text(
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
                                  child: CustomText(
                                      value:
                                          "Your response has been noted for the recycling program. You will receive the appropriate reward when the order reaches the warehouse.\n\nLatitude: $latitude\nLongitude: $longitude",
                                      textAlign: TextAlign.center,
                                      size: 16,
                                      color: Colors.grey),
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
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
            ),
          ]),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
