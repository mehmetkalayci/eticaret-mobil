import 'dart:convert';

import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/widgets/custom_radiobutton.dart';
import 'package:ecommerce_mobile/widgets/custom_title.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _valueOfPayment = 1;
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool isLoading = false;
  String paymentType = "";

  final _formKey = GlobalKey<FormState>();



  void completePayment() async {
    if (_formKey.currentState!.validate()) {
      if (_valueOfPayment == 1) {
        paymentType = "Kapıda Nakit Ödeme";
      } else if (_valueOfPayment == 2) {
        paymentType = "Kapıda Kredi Kartıyla Ödeme";
      } else {
        paymentType = "Ödeme Yöntemi Alınamadı";
      }

      setState(() {
        isLoading = true;
      });

      final response =
          await http.post(Uri.parse('http://qsres.com/api/mobileapp/purchase'),
              body: json.encode({
                "paymentType": paymentType,
                "appliedDiscountCode": "İndirim Kodu Gelecek",
                "address": addressController.text.trim(),
                "orderNotes": noteController.text.trim()
              }),
              encoding: Encoding.getByName("utf-8"),
              headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        // todo: belki cart i temizlemek gerekir

        Fluttertoast.showToast(msg: "Siparişleriniz alınmıştır.");
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Sipariş verebilmek için oturum açın.");
      } else {
        Fluttertoast.showToast(msg: response.body.toString());
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(context, Icons.payment_rounded, "Ödeme"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTitle(context, "ÖDEME YÖNTEMLERİ"),
                  CustomRadioListTile<int>(
                    value: 1,
                    groupValue: _valueOfPayment,
                    title: Text('Kapıda Nakit Ödeme',
                        style: TextStyle(fontSize: 18)),
                    subTitle: Text('Kapıda Ödeme',
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                    onChanged: (value) =>
                        setState(() => _valueOfPayment = value!),
                  ),
                  SizedBox(height: 10),
                  CustomRadioListTile<int>(
                    value: 2,
                    groupValue: _valueOfPayment,
                    title: Text('Kapıda Kredi Kartıyla Ödeme',
                        style: TextStyle(fontSize: 18)),
                    subTitle: Text('Kapıda Ödeme',
                        style: TextStyle(color: Colors.black54, fontSize: 16)),
                    onChanged: (value) =>
                        setState(() => _valueOfPayment = value!),
                  ),
                  //SizedBox(height: 10),
                  // CustomRadioListTile<int>(
                  //   value: 3,
                  //   groupValue: _valueOfPayment,
                  //   title: Text('Havale/EFT Ödeme',
                  //       style: TextStyle(fontSize: 18)),
                  //   subTitle: Text('Banka Aracılığıya Ödeme',
                  //       style: TextStyle(color: Colors.black54, fontSize: 16)),
                  //   onChanged: (value) => setState(() => _valueOfPayment = value!),
                  // ),
                  CustomTitle(context, "TESLİMAT ADRESİ"),
                  TextFormField(
                    controller: addressController,
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
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: (val) {
                      if (val != null && val.trim().length > 10) {
                        return null;
                      } else {
                        return "Teslimat adresi girin!";
                      }
                    },
                  ),
                  CustomTitle(context, "SİPARİŞ NOTUNUZ"),
                  TextFormField(
                    controller: noteController,
                    style: TextStyle(fontSize: 18),
                    minLines: 2,
                    maxLines: 2,
                    cursorColor: Colors.black,
                    cursorWidth: 0.75,
                    decoration: InputDecoration(
                      labelText: ("Notunuz"),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: 'Notunuz',
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
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: (val) {},
                  ),

                  Divider(height: 30),

                  MaterialButton(
                    onPressed: () {
                      completePayment();
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
                        Icon(Icons.check_circle),
                        SizedBox(width: 10),
                        Text(
                          "SİPARİŞİ ONAYLA - ${cart.totalAmount.toString()} ₺",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
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
