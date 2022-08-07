import 'package:ecommerce_mobile/screens/cart.dart';
import 'package:ecommerce_mobile/screens/signin.dart';
import 'package:ecommerce_mobile/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthCheckForCartPage extends StatelessWidget {
  UserAuthCheckForCartPage({Key? key}) : super(key: key);

  final _storage = SharedPreferences.getInstance();

  Future<bool> isTokenExpired() async {
    Object? token = await (await _storage).get("accessToken");

    if (token == null || token == "") {
      // access token yok
      return false;
    } else {
      // token süresi dolmuş mu kontrol et
      try {
        bool hasExpired = Jwt.isExpired(token.toString());
        return !hasExpired;
      } catch (e) {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isTokenExpired(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return CartPage();
          } else {
            return SigninPage();
          }
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
