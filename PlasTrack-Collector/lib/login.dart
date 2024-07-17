// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:plas_track2/HomeNavPage.dart';

// Define the User model
class Users {
  final String displayName;
  final String email;

  Users({
    required this.displayName,
    required this.email,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _loginMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Image.asset("images/icon.png"),
              SizedBox(height: 40),
              const ListTile(
                title: Text(
                  "Welcome to the Vendor App!",
                  style: TextStyle(fontSize: 26),
                ),
                subtitle: Text("Please log in to continue"),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email ID",
                        hintText: "Enter your email id",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), //Add spacing below the form
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(400, 50),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeNavPage()),
                    );
                  }
                },
                child: const Text("LOG IN"),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text(
                  "Don't have an account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const SignUpPage()),
                    // );
                  },
                  child: Text(
                    "Register Here",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent[700],
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _loginMessage,
                style: const TextStyle(color: Colors.red),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(400, 50),
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevents user from dismissing the dialog
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      );
                    },
                  );
                  await signInWithGoogle();
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeNavPage()),
                  );
                },
                child: const Text("Log in with Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Users> signInWithGoogle() async {
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In was canceled by the user.');
    }

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCred.user?.displayName);
    String displayName = userCred.user?.displayName ?? "";
    String email = userCred.user?.email ?? "";

    // Create a User object
    Users users = Users(
      displayName: displayName,
      email: email,
    );
    return users;
  } catch (e) {
    print("Google Sign-In Error: $e");
    rethrow; // Rethrow the error to handle it in the UI or caller function
  }
}
