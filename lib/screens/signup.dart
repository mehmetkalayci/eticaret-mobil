import 'dart:convert';

import 'package:ecommerce_mobile/models/hata_model.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:ecommerce_mobile/screens/agreement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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

  bool isChecked = false;
  bool _smsRequested = false;

  final _formKey = GlobalKey<FormState>();

  String error = '';

  bool isLoading = false;

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

  Future<void> _submitForm(context) async {
    if (_formKey.currentState!.validate()) {
      if (!isChecked) {
        Fluttertoast.showToast(
            msg: "Üyelik sözleşmesini kabul etmeniz gerekiyor.");
        return;
      }

      MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);

      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse('http://qsres.com/api/authentication/register'),
        body: json.encode({
          "fullName": adSoyadController.text.trim(),
          "businessName": firmaAdiController.text.trim(),
          "phone": telefonController.text.trim().replaceAll('-', ''),
          "password": telefonController.text.trim(),
          "address": adresController.text.trim(),
        }),
        headers: {"Content-Type": "application/json"},
        encoding: Encoding.getByName('utf-8'),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: response.body, toastLength: Toast.LENGTH_LONG);
        menu.setCurrentPage(3);
      } else {
        HataModel hata = HataModel.fromJson(jsonDecode(response.body));
        Fluttertoast.showToast(msg: hata.detail, toastLength: Toast.LENGTH_LONG);
      }

      setState(() {
        isLoading = false;
      });
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
                          child: AgreementPage(
                              title: "Üyelik Sözleşmesi",
                              agreementURL:
                                  "http://qsres.com/api/mobileapp/agreement"),
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
                      _submitForm(context);
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
                        Icon(Icons.person_add_rounded),
                        SizedBox(width: 10),
                        Text(
                          "Kayıt Ol",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
