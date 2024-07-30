// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TryNoti extends StatefulWidget {
  const TryNoti({super.key});

  @override
  State<TryNoti> createState() => _TryNotiState();
}

class _TryNotiState extends State<TryNoti> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _loading = false;
  String? mtoken;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    requestPermission();
    _retrieveToken();
    initInfo();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied or not accepted permission');
    }
  }

  Future<void> _retrieveToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("Device token is $mtoken");
      });
    });
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: (details) async {
      try {
        if (details.payload != null && details.payload!.isNotEmpty) {
          print("Notification Payload: ${details.payload}");
        }
      } catch (e) {
        print("Error in notification response: $e");
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("...............onMessage.............");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dbfood',
        'dbfood',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['body'],
      );
    });
  }

  Future<void> _sendNotification(
      String token, String body, String title) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true; // Start loading
      });

      final accessToken =
          'ya29.c.c0AY_VpZhjWC9RjcPX7-otdY8S0785z6cOIM25oIjAEIdrta592B70oukssEdOZWeDAanqaWA8H9EElhPwtqCHkeaXxJswwLlSGJIQ3PEk0SdN4yETIcBGpFEKThbFFJyt71_lNccjvdYsDchjgZvyEKUebvABWvMa76Yn2YeeVoSdX1GKm-ZedkcoaHuGXBmkyqBc7lzVMwSx3DEJHlMMlv-wq9TPXezfsvDJY1UQ-OLa---ewz6qjyI9TLBFKM6ZUdJWAi_HOjTULRXHP-oiQQ9lZ0qaaTazITIiDy90LqQra7NLcu_QV6tGkN5nKjuChUk3B9P-e85TxiEDPGhLUwJed460ZwPeNEiQqmBdomZ4VkEcpluGL-0nH385AZBmlkuy_Q0kIO5Rypja7-lnIi-W_5w_rrvwMUJZ_t86_yZ3gt42uRibyUM1kqfmd5v-b9bSU0Bs2_Wh3gvBwZsYFW_5Shcg1sollmo2ZSnJvjZVsjsxZuyebkmIitv2YeBzSfnpsg9urrnn9najhXWoubw8fW1_vMdU6JjMhapcsvrndkpkrOkmeVlq3q4cB8Rv9xc2i_I2eVoBjOeprFjYuR51ygh_e3h9qFSYJX24cUo2SxBqxk4VZzw5gx97uxzB3hQcFpdthB1JJZJtItYZpModnh8XOdm_X5ldy64c0Wt7UBkjnU4V0wjnm5Uk9g_wfd_VzqrJ-qifOkfnFF3riRo-OSfQOoFr4b4JpSJm26b0RnOwcrt1UfdQ-unQ7o4jMmecs8x3S07ce36fSJ8szRsiYZOUepy4pIn0eiBVjjyUVcrvoFrIOrg28W1sl2_te2wlrrQs5IFotvJVvh9dIqc8hhOdZi-21JlhQf_vrwZ58_k2_ufipv_3uwnFwS6JuYM8Ze-bmo53Wu_Soro-_Vjwx553vzScRtqw8cjmvtu60mxl2zXmxShsn2Jp2Wazyuntft-5VIf3Jd8hjSs9jarV5y4BioMQMRQRJRt-l27Y6SlpgQzc5in'; // Obtain this from OAuth 2.0 authentication
      final url =
          'https://fcm.googleapis.com/v1/projects/plastrack-ec49b/messages:send';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final data = {
        'message': {
          'token': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'android': {
            'priority': 'high',
          },
        },
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notification sent successfully')),
          );
        } else {
          throw Exception('Failed to send notification: ${response.body}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send notification: $e')),
        );
      } finally {
        setState(() {
          _loading = false; // Stop loading
        });
      }
    }
  }

  Future<void> sendNotificationsToAllUsers(String body, String title) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("UserTokens").get();
      for (var doc in snapshot.docs) {
        String token = doc['token'];
        await _sendNotification(
            token, body, title); // Ensure sending notification is awaited
      }
    } catch (e) {
      print("Error fetching user tokens: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Notification Body'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a notification body';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (!_loading) {
                      sendNotificationsToAllUsers(
                          _titleController.text, "Notification Test Title");
                    }
                  },
                  child: _loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        )
                      : Text('Send Notification'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
