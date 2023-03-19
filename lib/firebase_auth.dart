import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> getCurrentUser() async {
  return _auth.currentUser;
}
