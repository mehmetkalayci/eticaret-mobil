import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider() {
    _auth.setSettings(appVerificationDisabledForTesting: true);
  }

}