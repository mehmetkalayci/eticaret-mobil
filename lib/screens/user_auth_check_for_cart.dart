import 'package:ecommerce_mobile/providers/auth_provider.dart';
import 'package:ecommerce_mobile/screens/cart.dart';
import 'package:ecommerce_mobile/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAuthCheckForCartPage extends StatelessWidget {
  UserAuthCheckForCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    return auth.isLoggedIn ? CartPage() : SigninPage();
  }
}
