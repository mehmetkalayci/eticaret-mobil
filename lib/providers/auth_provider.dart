import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _storage = SharedPreferences.getInstance();

class AuthProvider with ChangeNotifier {

  String _token = "";
  String get token => _token;

  void SetToken(String value) {
    _token = value;
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void SetIsLoggedIn(bool value) {
    _isLoggedIn = value;
  }


  void Logout() async {
     await (await _storage).remove("accessToken");
     SetIsLoggedIn(false);
     SetToken("");
     notifyListeners();
  }


  Future<String> getValidToken() async {
    Object? token = await (await _storage).get("accessToken");

    if (token == null || token == "") {
      // access token yok
      return "";
    } else {
      // token süresi dolmuş mu kontrol et
      try {
        if (Jwt.isExpired(token.toString())) {
          return "";
        } else {
          return token.toString();
        }
      } catch (e) {
        return "";
      }
    }
  }

  InitAuth() async {
    String tokenValue = await getValidToken();
    if (tokenValue != '') {
      _isLoggedIn = true;
      _token = tokenValue;
    } else {
      _isLoggedIn = false;
      _token = "";
    }
    notifyListeners();
  }

}
