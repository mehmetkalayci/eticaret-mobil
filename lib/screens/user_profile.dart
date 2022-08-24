import 'dart:convert';

import 'package:ecommerce_mobile/models/profile_model.dart';
import 'package:ecommerce_mobile/providers/auth_provider.dart';
import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Future<ProfileModel?> getProfile(String token) async {
    final response = await http.get(
      Uri.parse("http://api.qsres.com/authentication/me"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> deleteAccount(String token) async {
    final response = await http.post(
      Uri.parse("http://api.qsres.com/authentication/delete"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: response.body.toString());
      return true;
    } else {
      Fluttertoast.showToast(msg: "Hata Oluştu!\n" + response.body.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    CartProvider cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: getProfile(auth.token),
        builder: (BuildContext context, AsyncSnapshot<ProfileModel?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return Center(child: Text("Profil bilgisi getirilemedi!"));
            } else {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: BorderSide(
                              width: 3,
                              color: Color.fromARGB(255, 202, 202, 202)),
                        ),
                        child: Image.asset(
                          "assets/images/pp.jpg",
                          height: 100,
                        ),
                      ),
                    ),
                    Text(
                      snapshot.data!.fullName,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      snapshot.data!.businessName,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      snapshot.data!.phone,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    MaterialButton(
                      onPressed: () async {
                        menu.setCurrentPage(0);
                        auth.Logout();
                        cart.cartItems.clear();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Çıkış Yap"),
                          SizedBox(width: 10),
                          Icon(Icons.exit_to_app)
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    /****************************************************/
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: MaterialButton(
                          onPressed: () {
                            menu.setCurrentPage(8);
                          },
                          height: 60,
                          color: Colors.grey.shade200,
                          focusElevation: 0,
                          highlightElevation: 0,
                          hoverElevation: 0,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.shopping_bag_rounded),
                              SizedBox(width: 10),
                              Text(
                                "Sipariş Geçmişi",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_rounded)
                            ],
                          )),
                    ),

                    //
                    // Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    //   child: MaterialButton(
                    //     onPressed: () {
                    //       // todo user promotion sayfası açılacak
                    //     },
                    //     height: 60,
                    //     color: Colors.grey.shade200,
                    //     focusElevation: 0,
                    //     highlightElevation: 0,
                    //     hoverElevation: 0,
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Icon(Icons.discount_rounded),
                    //         SizedBox(width: 10),
                    //         Text(
                    //           "Bana Özel",
                    //           style: TextStyle(
                    //               fontSize: 18, fontWeight: FontWeight.w400),
                    //         ),
                    //         Spacer(),
                    //         Icon(Icons.arrow_forward_rounded)
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: MaterialButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Hesap Silinsin Mi?"),
                                content:
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Hesap silme işlemi  '),
                                      TextSpan(
                                        text: 'geri alınamaz!',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  MaterialButton(
                                    color: Colors.red.shade600,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                    hoverElevation: 0,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Evet, Hesabım Silinsin!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      deleteAccount(auth.token).then((value) {
                                        if (value) {
                                          auth.Logout();
                                          cart.cartItems.clear();
                                          Navigator.pop(context);
                                          menu.setCurrentPage(0);
                                        }
                                      });
                                    },
                                  ),
                                  MaterialButton(
                                    color: Colors.grey.shade200,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                    hoverElevation: 0,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text("İptal"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        height: 60,
                        color: Colors.red.shade600,
                        textColor: Colors.white,
                        focusElevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.no_accounts_rounded),
                            SizedBox(width: 10),
                            Text(
                              "Hesabımı Sil",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 120),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
