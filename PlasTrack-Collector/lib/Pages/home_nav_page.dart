// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:plas_track2/Pages/home_page.dart';
import 'package:plas_track2/Pages/NGO/map_page.dart';
import 'package:plas_track2/Pages/NGO/payment_page.dart';
import 'package:plas_track2/Pages/side_bar.dart';
import 'package:plas_track2/Utils/constants.dart';
import 'package:plas_track2/Widgets/custom_text.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({super.key});
  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> {
  int _currentindex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    //MapTry(),
    MapPage(),
    Paymentpage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: CustomText(value: "Plastrack", color: white),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _widgetOptions[_currentindex], // Display the selected widget
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white, // Set the unselected icon color
        selectedItemColor: const Color.fromARGB(
            255, 171, 171, 171), // Set the selected icon color
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "About Us",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: "View Map",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "View Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: "Credit Money",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
        currentIndex: _currentindex,
        selectedFontSize: 10,
        iconSize: 35,
      ),
    );
  }
}
