// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plas_track2/Models/user_model.dart';

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
