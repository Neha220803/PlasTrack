import 'package:flutter/material.dart';
import 'package:plas_track2/Functions/auth.dart';
import 'package:plas_track2/Pages/home_nav_page.dart';
import 'package:plas_track2/Utils/constants.dart';
import 'package:plas_track2/Widgets/custom_text.dart';
import 'package:plas_track2/Widgets/custome_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
              const SizedBox(height: 150),
              Image.asset("images/icon.png"),
              const SizedBox(height: 40),
              const ListTile(
                title: CustomText(
                  value: "Welcome to the Vendor App!",
                  size: 26,
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
              CustomButton(
                text: "LOG IN",
                callback: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeNavPage()),
                    );
                  }
                },
                fixedSize: const Size(400, 50),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const CustomText(
                  value: "Don't have an account?",
                  textAlign: TextAlign.center,
                  size: 18,
                  fontWeight: FontWeight.bold,
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
                style: const TextStyle(color: red),
              ),
              CustomButton(
                text: "Log in with Google",
                fixedSize: const Size(400, 50),
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
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeNavPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
