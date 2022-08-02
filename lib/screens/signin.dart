import 'package:ecommerce_mobile/models/user_model.dart';
import 'package:ecommerce_mobile/screens/signup.dart';
import 'package:ecommerce_mobile/screens/user_profile.dart';
import 'package:ecommerce_mobile/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _smsRequested = false;

  String _phoneNumber = '';
  String _verificationId = '';
  bool isLoading = false;

  Future<void> _submitAndVerifyPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      if (!_smsRequested) {
        _phoneNumber = '+90' + phoneController.text.replaceAll('-', '');

        _verifyPhoneNumber();
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

  void _verifyPhoneNumber() async {
    if (mounted)
      setState(() {
        isLoading = true;
      });

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      Fluttertoast.showToast(msg: authException.message.toString());
    };

    final PhoneCodeSent codeSent =
        (String verificationId, int? forceResendingToken) async {
      Fluttertoast.showToast(
          msg: "Telefonunuza SMS ile doğrulama kodunu gönderdik.");
      setState(() {
        _verificationId = verificationId;
        _smsRequested = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      print("verificationCompleted");
    };

    await _auth
        .verifyPhoneNumber(
            phoneNumber: _phoneNumber,
            timeout: const Duration(seconds: 60),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
        .then((value) {
      print("then");
    }).catchError((onError) {
      print(onError);
    });

    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  void _signInWithPhoneNumber(String otp) async {
    _showProgressDialog(true);

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      final User? user = (await _auth.signInWithCredential(credential)).user;
      final User? currentUser = _auth.currentUser;
      assert(user?.uid == currentUser?.uid);

      final prefs = await SharedPreferences.getInstance();

      _showProgressDialog(false);
      if (user != null) {
        await prefs.setString('userUid', user.uid);
        await prefs.setString('userPhone', this._phoneNumber);

        // todo kullanıcıyı db ye kaydet

        print(user);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => UserProfilePage(
        //         //user: user,
        //         ),
        //   ),
        // );
      } else {
        Fluttertoast.showToast(msg: "Oturum açılamadı!");
      }
    } on FirebaseAuthException catch (authError) {
      if (authError.code == 'invalid-verification-code') {
        Fluttertoast.showToast(
            msg: "Hatalı doğrulama kodu girdiniz!",
            toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(
            msg: "Hata oluştu :(\n" + authError.message.toString(),
            toastLength: Toast.LENGTH_LONG);
      }
      _showProgressDialog(false);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Hata oluştu :(\n" + e.toString(),
          toastLength: Toast.LENGTH_LONG);
      _showProgressDialog(false);
    }
  }

  _showProgressDialog(bool isloadingstate) {
    if (mounted)
      setState(() {
        isLoading = isloadingstate;
      });
  }

  verifyOtp(String otpText) async {
    _signInWithPhoneNumber(otpText);
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
                      if (_smsRequested) {
                        verifyOtp(otpController.text.trim());
                      } else {
                        _submitAndVerifyPhoneNumber();
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupPage(),
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
}
