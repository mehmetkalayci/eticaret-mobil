import 'package:ecommerce_mobile/providers/auth_provider.dart';
import 'package:ecommerce_mobile/screens/signin.dart';
import 'package:ecommerce_mobile/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthCheckForSigninPage extends StatelessWidget {
  UserAuthCheckForSigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return auth.isLoggedIn ? UserProfilePage() : SigninPage();
  }
}
