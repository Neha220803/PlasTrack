// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plas_track/NGO/MapPage.dart';
import 'package:plas_track/SideNavBar/TryNotiPage.dart';
import 'package:plas_track/login.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

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
            padding: EdgeInsets.all(20),
            color: Colors.black,
            child: Center(
              child: Text(
                "${_user?.displayName ?? 'No Names'}",
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text("View Maps"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Try Notification"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TryNoti()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text("Log Out"),
            onTap: () async {
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
      ),
    );
  }
}
