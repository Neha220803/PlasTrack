// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plas_track2/Pages/collection_history.dart';
import 'package:plas_track2/Pages/collection_req.dart';
import 'package:plas_track2/Pages/past_orders.dart';
import 'package:plas_track2/Pages/login.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            padding: const EdgeInsets.all(20),
            color: Colors.black,
            child: Center(
              child: Text(
                _user?.displayName ?? 'No Names',
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Collection Requests'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CollectionRequest()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_edu),
            title: const Text('Collection History'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CollecHistory()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Transaction History'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PastOrders()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text("Log Out"),
            onTap: () async {
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          )
        ],
      ),
    );
  }
}
