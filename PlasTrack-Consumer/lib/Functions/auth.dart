import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plas_track/Models/user_model.dart';

Future<Users> signInWithGoogle() async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
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
}
