import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
      return Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/choose.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                    20, 50, 20, 20), // Adjust top padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome to our innovative world of sustainability!",
                      style: TextStyle(
                        color: Colors.black54, //Updated Color
                        fontSize: 30, //Increased font size
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            'Pacifico', // Change to a more attractive font
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20), // Increased spacing
                    Text(
                      "We're on a mission to empower individuals to make a positive impact on the environment. Our app seamlessly connects you to recycling solutions, educational resources, and a community of like-minded changemakers. Join us in creating a greener future, one small action at a time.",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18, // Increased font size
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}
