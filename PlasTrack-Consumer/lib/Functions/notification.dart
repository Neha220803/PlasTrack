import 'package:cloud_firestore/cloud_firestore.dart';

void saveToken(String token, user) async {
  String googleUserName = user?.displayName ?? 'temp';
  await FirebaseFirestore.instance
      .collection("UserTokens")
      .doc(googleUserName)
      .set({'token': token});
}
