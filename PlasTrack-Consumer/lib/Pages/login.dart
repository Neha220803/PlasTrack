// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:plas_track/Functions/auth.dart';
import 'package:plas_track/Functions/notification.dart';
import 'package:plas_track/Pages/home_nav_page.dart';
import 'package:plas_track/Utils/constants.dart';
import 'package:plas_track/Widgets/custom_text.dart';
import 'package:plas_track/Widgets/custome_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? mtoken = " ";
  late User? _user;
  final String _loginMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = currentUser;
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!, _user);
    });
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
              const SizedBox(height: 150),
              Image.asset("images/icon.png"),
              const SizedBox(height: 40),
              const ListTile(
                title: CustomText(
                  value: "Welcome!",
                  size: 30,
                ),
                subtitle: CustomText(value: "Please log in to continue"),
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

              CustomButton(
                text: "LOG IN",
                fixedSize: const Size(400, 50),
                callback: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeNavPage()),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const CustomText(
                    value: "Don't have an account?",
                    textAlign: TextAlign.center,
                    size: 18,
                    fontWeight: FontWeight.bold),
                subtitle: TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const SignUpPage()),
                      // );
                    },
                    child: CustomText(
                      value: "Register Here",
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent[700],
                      size: 17,
                      decoration: TextDecoration.underline,
                    )),
              ),
              const SizedBox(height: 10),

              CustomText(
                value: _loginMessage,
                color: red,
              ),

              CustomButton(
                text: "Log in with Google",
                callback: () async {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevents user from dismissing the dialog
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      );
                    },
                  );

                  await signInWithGoogle();
                  _fetchUser();
                  getToken();
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeNavPage()),
                  );
                },
                fixedSize: const Size(400, 50),
              )
            ],
          ),
        ),
      ),
    );
  }
}
