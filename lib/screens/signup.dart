import 'package:dio/dio.dart';
import 'package:ecommerce_mobile/models/user_model.dart';
import 'package:ecommerce_mobile/screens/agreement.dart';
import 'package:ecommerce_mobile/screens/user_profile.dart';
import 'package:ecommerce_mobile/services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController adSoyadController = TextEditingController();
  TextEditingController firmaAdiController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  TextEditingController adresController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  bool TelefonKontrolEt(String telefonNo) {
    if (_formKey.currentState!.validate()) {
      if(!isChecked){
        Fluttertoast.showToast(msg: "Üyelik sözleşmesini kabul etmeniz gerekiyor.");
        return false;
      }

      bool _smsRequestYapilabilir = false;

      Api().api.post("authentication/check-user",
          data: {"phone": telefonController.text.trim()}).then((value) {
        // Ok dönmüştür
        _smsRequestYapilabilir = true;
      }).catchError((DioError error) {
        _smsRequestYapilabilir = false;

        print(error);
        Fluttertoast.showToast(msg: error.toString());


        if (error.error["statusCode"] == 404) {
          Fluttertoast.showToast(msg: "Bu telefon numarasıyla zaten bir kayıt oluşturulmuş!");
        } else {
          Fluttertoast.showToast(msg: error.toString());
        }
      });
      return _smsRequestYapilabilir;
    }
    return false;
  }

  bool isChecked = false;
  bool _smsRequested = false;
  String _phoneNumber = '';

  final _formKey = GlobalKey<FormState>();

  String error = '';

  String _verificationId = '';
  bool isLoading = false;

  Future<void> _submitAndVerifyPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      if(!isChecked){
        Fluttertoast.showToast(msg: "Üyelik sözleşmesini kabul etmeniz gerekiyor.");
        return;
      }

      if (!_smsRequested) {
        _phoneNumber = '+90' + telefonController.text.replaceAll('-', '');

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
      Fluttertoast.showToast(
          msg: authException.message.toString(),
          toastLength: Toast.LENGTH_LONG);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, int? forceResendingToken) async {
      Fluttertoast.showToast(
          msg: "Telefonunuza SMS ile doğrulama kodunu gönderdik.",
          toastLength: Toast.LENGTH_LONG);
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

        UserModel userModel = UserModel(
          fullName: adSoyadController.text.trim(),
          businessName: firmaAdiController.text.trim(),
          phone: telefonController.text.trim(),
          password: sifreController.text.trim(),
          address: adresController.text.trim(),
        );

        Api().register(userModel).then((value) {
          Fluttertoast.showToast(msg: value, toastLength: Toast.LENGTH_LONG);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(
                  //user: user,
                  ),
            ),
          );
        }).catchError((error) {
          Fluttertoast.showToast(
              msg: error.toString(), toastLength: Toast.LENGTH_LONG);
        });

        print(user);
      } else {
        Fluttertoast.showToast(msg: "Kullanıcı doğrulama başarısız!");
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      UserModel userModel = UserModel(
        fullName: adSoyadController.text.trim(),
        businessName: firmaAdiController.text.trim(),
        phone: telefonController.text.trim(),
        password: telefonController.text.trim(),
        address: adresController.text.trim(),
      );

      Api().register(userModel).then((value) async {});
    }
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
                  Image.asset(
                    "assets/images/logo.png",
                    height: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Kaydol",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: adSoyadController,
                    style: TextStyle(fontSize: 18),
                    cursorColor: Colors.black,
                    cursorWidth: 0.75,
                    decoration: InputDecoration(
                      labelText: ("Ad Soyad"),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Ad Soyad',
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (val) {
                      if (val.toString().trim().length < 5) {
                        return 'Ad soyad girin';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: firmaAdiController,
                    style: TextStyle(fontSize: 18),
                    cursorColor: Colors.black,
                    cursorWidth: 0.75,
                    decoration: InputDecoration(
                      labelText: ("Firma Adı"),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Firma Adı',
                      prefixIcon: Icon(
                        Icons.business_center_rounded,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (val) {
                      if (val.toString().trim().length < 5) {
                        return 'Firma adı girin';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: telefonController,
                    maxLength: 12,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    style: TextStyle(fontSize: 18),
                    cursorColor: Colors.black,
                    cursorWidth: 0.75,
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
                    textInputAction: TextInputAction.done,
                    validator: (val) {
                      return _validateMobile(val ?? "");
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: sifreController,
                    obscureText: true,
                    style: TextStyle(fontSize: 18),
                    cursorColor: Colors.black,
                    cursorWidth: 0.75,
                    decoration: InputDecoration(
                      labelText: ("Şifre"),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (val) {
                      if (val.toString().trim().length < 6) {
                        return 'En az 6 karakterli bir şifre girin';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: adresController,
                    style: TextStyle(fontSize: 18),
                    minLines: 2,
                    maxLines: 2,
                    cursorColor: Colors.black,
                    cursorWidth: 0.75,
                    decoration: InputDecoration(
                      labelText: ("Adres"),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Adres',
                      prefixIcon: Icon(
                        Icons.pin_drop_rounded,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (val) {
                      if (val.toString().trim().length < 15) {
                        return 'Adres girin';
                      } else {
                        return null;
                      }
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
                        hintText: "Doğrulama Kodu",
                        prefixIcon:
                            Icon(Icons.password_rounded, color: Colors.grey),
                        filled: true,
                      ),
                      textInputAction: TextInputAction.done,
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
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Üye Ol’a basarak Üyelik Koşullarını kabul ediyorum.",
                    ),
                    value: isChecked,
                    onChanged: (newValue) async {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: AgreementPage(),
                        ),
                      );

                      setState(() {
                        isChecked = !this.isChecked;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  SizedBox(height: 15),
                  MaterialButton(
                    onPressed: () async {
                      if(TelefonKontrolEt(telefonController.text.trim())) {
                        if (_smsRequested) {
                          verifyOtp(otpController.text.trim());
                        } else {
                          _submitAndVerifyPhoneNumber();
                        }
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
                        Icon(Icons.person_add_rounded),
                        SizedBox(width: 10),
                        Text(
                          "Üye Ol",
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
                        Navigator.pop(context);
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
                        "Geri",
                        style: TextStyle(fontSize: 18),
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
