// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationData {
  final double? latitude;
  final double? longitude;
  final String? status;
  final Timestamp timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.timestamp,
  });
}

String formattedTimestamp(DateTime timestamp) {
  String formattedDate = DateFormat('MMMM d, y').format(timestamp);

  return '$formattedDate';
}

class CollecHistory extends StatefulWidget {
  const CollecHistory({super.key});

  @override
  State<CollecHistory> createState() => _CollecHistoryState();
}

class _CollecHistoryState extends State<CollecHistory> {
  final CollectionReference _location =
      FirebaseFirestore.instance.collection('location');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _location.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Collection Requests",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  var transactionData =
                      snapshot.data?.docs[index].data() as Map<String, dynamic>;
                  var transaction = LocationData(
                    latitude: transactionData['latitude'],
                    longitude: transactionData['longitude'],
                    timestamp: transactionData['timestamp'],
                    status: transactionData['status'],
                  );

                  // Check if the status is "pending"
                  if (transaction.status == 'collected') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Card(
                        elevation: 4,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            "Plastic Collected",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text('Coordinates: (' +
                                  transaction.latitude.toString() +
                                  ',' +
                                  transaction.longitude.toString() +
                                  ')'),
                              Text(
                                'Requested on ${formattedTimestamp(transaction.timestamp.toDate())}',
                                style: TextStyle(
                                  color: Color(0xFF898989),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.forward),
                            onPressed: () {
                              launchUrl(Uri.parse(
                                'https://www.google.com/maps/search/?api=1&query=${transaction.latitude},${transaction.longitude}',
                              ));
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    // If status is not "pending", return an empty container
                    return Container();
                  }
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
