import 'dart:ffi';

import 'package:ecommerce_mobile/screens/user_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String error = '';
  bool _smsRequested = false;

  String _phoneNumber = '';
  String _verificationId = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (!_smsRequested) {
        _phoneNumber = '+90' + phoneController.text.replaceAll('-', '');
        await _phoneAuth(_phoneNumber);
      } else {
        final smsCode = otpController.text;

        if (smsCode != null) {
          // Create a PhoneAuthCredential with the code
          final credential = PhoneAuthProvider.credential(
            verificationId: _verificationId,
            smsCode: smsCode,
          );

          print("credential");
          print(credential.token);
          print(credential);

          Fluttertoast.showToast(
              msg: credential.toString(), toastLength: Toast.LENGTH_LONG);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oturum açılıyor...')),
        );
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

  @override
  Widget build(BuildContext context) {
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
                  Image.asset("assets/images/logo.png", height: 40),
                  SizedBox(height: 100),
                  Text(
                    "Giriş Yap",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Visibility(
                    visible: error.isNotEmpty,
                    child: MaterialBanner(
                      backgroundColor: Theme.of(context).errorColor,
                      content: Text(error),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              error = '';
                            });
                          },
                          child: const Text(
                            ' X ',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                      contentTextStyle: const TextStyle(color: Colors.white),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    maxLength: 12,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
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
                      )),
                  SizedBox(height: 15),



                  MaterialButton(
                    onPressed: () {
                      _submitForm();
                      //await _phoneAuth();
                    },
                    height: 60,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                              fontSize: 18, fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),


                  SizedBox(height: 15),


                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserRegisterPage(),
                          ),
                        );
                      },
                      height: 60,
                      focusElevation: 0,
                      highlightElevation: 0,
                      hoverElevation: 0,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Kaydol",
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

  Future<void> _phoneAuth(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential

        otpController.text = credential.smsCode ?? "";

        //todo: veritabanına kayıt yapılacak
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        // todo: hata mesajı göster
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        setState(() {
          _smsRequested = true;
          _verificationId = verificationId;
        });

        //show dialog to take input from the user
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  title: Text("Doğrulama Kodunu Girin"),
                  content: TextField(),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text("Done"),
                      textColor: Colors.white,
                      color: Colors.redAccent,
                      onPressed: () {},
                    )
                  ],
                ));
      },
      timeout: Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
