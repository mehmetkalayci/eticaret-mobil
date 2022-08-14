import 'dart:convert';

import 'package:ecommerce_mobile/models/hata_model.dart';
import 'package:ecommerce_mobile/models/login_response_model.dart';
import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../providers/auth_provider.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _storage = SharedPreferences.getInstance();

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _smsRequested = false;
  bool isLoading = false;

  int tryCounter = 1;

  void _requestSMS() async {
    if (_formKey.currentState!.validate()) {
      if (!_smsRequested) {
        setState(() {
          isLoading = true;
        });

        String phoneNumber = phoneController.text.trim().replaceAll('-', '');
        otpController.clear();

        final uri =
            Uri.parse('http://api.qsres.com/authentication/sms-request');

        final response = await http.post(uri,
            body: json.encode({'phone': phoneNumber}),
            headers: {"Content-Type": "application/json"},
            encoding: Encoding.getByName("utf-8"));

        if (response.statusCode == 200) {
          _smsRequested = true;
          Fluttertoast.showToast(msg: response.body);
        } else {
          HataModel hata = HataModel.fromJson(jsonDecode(response.body));
          _smsRequested = false;
          Fluttertoast.showToast(
              msg: "Doğrulama kodu gönderilirken hata oluştu!\n" + hata.detail);
        }

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? _validateMobile(String value) {
    String pattern = r'^(([0-9]{3,3})-([0-9]{3,3})-([0-9]{4,4}))$';

    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Telefon numarası girin!';
    } else if (!regExp.hasMatch(value)) {
      return 'Geçerli bir telefon numarası girin!\nNumaranızı başında 0 olmadan girin.';
    }
    return null;
  }

  _submitAndVerifyPhoneNumber(context) async {
    if (_formKey.currentState!.validate()) {
      MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);

      setState(() {
        isLoading = true;
      });

      String phoneNumber = phoneController.text.trim().replaceAll('-', '');

      AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);



        final response = await http.post(
          Uri.parse('http://api.qsres.com/authentication/login'),
          body: json.encode({
            'phone': phoneNumber,
            'smsConfirmationCode': otpController.text.trim()
          }),
          headers: {"Content-Type": "application/json"},
          encoding: Encoding.getByName("utf-8"),
        );



      if (response.statusCode == 200) {
          LoginResponseModel responseModel = LoginResponseModel.fromJson(json.decode(response.body));

          await (await _storage).setString("accessToken", responseModel.token);
          auth.InitAuth();
          menu.setCurrentPage(0);
          Provider.of<CartProvider>(context, listen: false).loadItems();

        } else {
          HataModel hata = HataModel.fromJson(jsonDecode(response.body));
          Fluttertoast.showToast(msg: hata.detail);
        }


      setState(() {
        isLoading = false;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                  SizedBox(height: 50),
                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    style: TextStyle(fontSize: 18),
                    cursorColor: Colors.black,
                    cursorWidth: 0.75,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      MaskTextInputFormatter(mask: '###-###-####')
                    ],
                    decoration: InputDecoration(
                      labelText: ("Cep Telefonu"),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: '123-456-7890',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon:
                          Icon(Icons.phone_iphone_rounded, color: Colors.grey),
                      counterText: "",
                      filled: true,
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: (val) {
                      return _validateMobile(val ?? "");
                    },
                  ),
                  SizedBox(height: 15),
                  Visibility(
                    visible: _smsRequested,
                    child: TextFormField(
                      style: TextStyle(fontSize: 18),
                      inputFormatters: [MaskTextInputFormatter(mask: '####')],
                      cursorColor: Colors.black,
                      cursorWidth: 0.75,
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: "Doğrulama Kodu",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Doğrulama Kodu',
                        prefixIcon:
                            Icon(Icons.password_rounded, color: Colors.grey),
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      validator: (val) {
                        if (val != null && val.trim().isNotEmpty) {
                          return null;
                        } else {
                          return "SMS ile gelen doğrulama kodunu girin!";
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  MaterialButton(
                    onPressed: () {
                      if (!_smsRequested) {
                        _requestSMS();
                      } else {
                        _submitAndVerifyPhoneNumber(context);
                      }
                    },
                    height: 60,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.login),
                        SizedBox(width: 10),
                        Text(
                          "Giriş Yap",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        menu.setCurrentPage(4);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SignupPage(),
                        //   ),
                        // );
                      },
                      height: 60,
                      focusElevation: 0,
                      highlightElevation: 0,
                      hoverElevation: 0,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Kayıt Ol",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
