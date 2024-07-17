import 'package:flutter/material.dart';
import 'package:plas_track/Home/AccountPage.dart';
import 'package:plas_track/Home/DonatePage.dart';
import 'package:plas_track/Home/HomePage.dart';
import 'package:plas_track/SideNavBar/SideBar.dart';

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
    DonatePlasticPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text(
          "Plastrack",
          style: TextStyle(color: Colors.white),
        ),
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
            icon: Icon(Icons.shopping_bag_rounded),
            label: "Donate Plastic",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
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
