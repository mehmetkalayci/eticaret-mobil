import 'dart:convert';

import 'package:ecommerce_mobile/models/hata_model.dart';
import 'package:ecommerce_mobile/models/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final _storage = SharedPreferences.getInstance();


class AuthProvider with ChangeNotifier {

  AuthProvider()  {
    getValidToken().then((value) {
      if(value != ""){
        SetToken(value);
        SetIsLoggedIn(true);
      }else{
        SetToken("");
        SetIsLoggedIn(false);
      }
    });
  }

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

  void Login(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse('http://qsres.com/api/authentication/login'),
      body: json.encode({
        'phone': phoneNumber,
        'smsConfirmationCode': otp
      }),
      headers: {"Content-Type": "application/json"},
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      LoginResponseModel responseModel = LoginResponseModel.fromJson(json.decode(response.body));
      await (await _storage).setString("accessToken", responseModel.token);

      SetToken(responseModel.token);
      SetIsLoggedIn(true);
      notifyListeners();

    } else {
      HataModel hata = HataModel.fromJson(jsonDecode(response.body));
      Fluttertoast.showToast(msg: hata.detail);

      SetToken("");
      SetIsLoggedIn(false);
      notifyListeners();
    }
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

  // SetAuthorizationInfo() async {
  //   String tokenValue = await getValidToken();
  //   if (tokenValue != '') {
  //     _isLoggedIn = true;
  //     _token = tokenValue;
  //   } else {
  //     _isLoggedIn = false;
  //     _token = "";
  //   }
  //   notifyListeners();
  // }

}
