import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _storage = SharedPreferences.getInstance();

Future<bool> checkToken() async {
  Object? token = await (await _storage).get("accessToken");

  if (token == null || token =="") {
    // access token yok
    return false;
  } else {
    // token süresi dolmuş mu kontrol et
    try {
      bool hasExpired = Jwt.isExpired(token.toString());
      return !hasExpired;
    }catch (e){
      return false;
    }
  }
}

class AuthProvider with ChangeNotifier {

  bool _isLoggedIn = false;
  bool get getIsLoggedIn => _isLoggedIn;


  IsLoggeIn() {
    checkToken().then((value) {
      _isLoggedIn = value;
      notifyListeners();
    });
  }



}