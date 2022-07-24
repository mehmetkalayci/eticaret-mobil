import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserProfileEditPage extends StatefulWidget {
  const UserProfileEditPage({Key? key}) : super(key: key);

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String error = '';
  bool _smsRequested = false;

  String _phoneNumber = '';
  String _verificationId = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {}
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

  /*****************************************/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          fit: StackFit.expand,
          children: [
        CustomScrollView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          slivers: <Widget>[
            MyAppBar(
                "Bilgilerini Düzenle", Icon(Icons.person_rounded), context),
            SliverToBoxAdapter(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                          contentTextStyle:
                              const TextStyle(color: Colors.white),
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
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
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        validator: (val) {},
                      ),
                      SizedBox(height: 15),
                      TextFormField(
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
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        validator: (val) {},
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
                          prefixIcon: Icon(Icons.phone_iphone_rounded,
                              color: Colors.grey),
                          counterText: "",
                          filled: true,
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        validator: (val) {
                          return _validateMobile(val ?? "");
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
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
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        validator: (val) {},
                      ),
                      SizedBox(height: 15),
                      Visibility(
                        visible: false,
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
                            prefixIcon: Icon(Icons.password_rounded,
                                color: Colors.grey),
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
                        onPressed: () {},
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
                            Icon(Icons.check_circle),
                            SizedBox(width: 10),
                            Text(
                              "Kaydet",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
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
          ],
        ),
      ]),
    );
  }
}
