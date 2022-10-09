import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:ecommerce_mobile/models/config_model.dart';
import 'package:ecommerce_mobile/providers/auth_provider.dart';
import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Widget MyDrawerMenu(BuildContext context) {
  MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);
  CartProvider cart = Provider.of<CartProvider>(context, listen: false);
  AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

  Future<ConfigModel?> fetchConfig() async {
    final response =
        await http.get(Uri.parse('http://api.qsres.com/mobileapp/config'));

    if (response.statusCode == 200) {
      return ConfigModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  return Drawer(
    child: Column(children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Image.asset(
            "assets/images/logo-drawer.png",
            height: 85,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      ListTile(
        minLeadingWidth: 20,
        leading: Icon(Icons.home_rounded),
        title: const Text('Anasayfa'),
        onTap: () {
          menu.setCurrentPage(0);
          Navigator.of(context).pop();
        },
      ),
      Divider(height: 0),
      ListTile(
        minLeadingWidth: 20,
        leading: Icon(Icons.search_rounded),
        title: const Text('Ürün Ara'),
        onTap: () {
          menu.setCurrentPage(1);
          Navigator.of(context).pop();
        },
      ),
      Divider(height: 0),
      ListTile(
        minLeadingWidth: 20,
        leading: Badge(
          badgeContent: Text(
            cart.getTotalItemCount.toString(),
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          child: Icon(Icons.shopping_basket_rounded),
        ),
        title: const Text('Sepet'),
        onTap: () {
          menu.setCurrentPage(2);
          Navigator.of(context).pop();
        },
      ),
      Divider(height: 0),
      if (auth.isLoggedIn)
        ListTile(
          minLeadingWidth: 20,
          leading: Icon(Icons.person_rounded),
          title: const Text('Hesabım'),
          onTap: () {
            menu.setCurrentPage(3);
            Navigator.of(context).pop();
          },
        ),
      // Divider(height: 0),
      // ListTile(
      //   minLeadingWidth: 20,
      //   leading: Icon(Icons.discount_rounded),
      //   title: const Text('Bana Özel'),
      //   onTap: () {},
      // ),

      if (!auth.isLoggedIn)
        ListTile(
          minLeadingWidth: 20,
          leading: Icon(Icons.login),
          title: const Text('Kayıt Ol'),
          onTap: () {
            menu.setCurrentPage(4);
            Navigator.of(context).pop();
          },
        ),
      Divider(height: 0),
      if (!auth.isLoggedIn)
        ListTile(
          minLeadingWidth: 20,
          leading: Icon(Icons.discount_rounded),
          title: const Text('Giriş Yap'),
          onTap: () {
            menu.setCurrentPage(3);
            Navigator.of(context).pop();
          },
        ),
      // Divider(height: 0),
      // ListTile(
      //   minLeadingWidth: 20,
      //   leading: Icon(Icons.money_rounded),
      //   title: const Text('Banka Hesap Bilgilerimiz'),
      //   onTap: () {
      //     //menu.setCurrentPage(1);
      //     Navigator.of(context).pop();
      //   },
      // ),
      // Divider(height: 0),
      // ListTile(
      //   minLeadingWidth: 20,
      //   leading: Icon(Icons.privacy_tip_rounded),
      //   title: const Text('Gizlilik Politikası'),
      //   onTap: () {
      //     //menu.setCurrentPage(1);
      //     Navigator.of(context).pop();
      //   },
      // ),
      // Divider(height: 0),
      // ListTile(
      //   minLeadingWidth: 20,
      //   leading: Icon(Icons.verified_rounded),
      //   title: const Text('Şartlar ve Koşullar'),
      //   onTap: () {
      //     //menu.setCurrentPage(1);
      //     Navigator.of(context).pop();
      //   },
      // ),
      // Divider(height: 0),
      // ListTile(
      //   minLeadingWidth: 20,
      //   leading: Icon(Icons.info_outline_rounded),
      //   title: const Text('Hakkımızda'),
      //   onTap: () {
      //     //menu.setCurrentPage(1);
      //     Navigator.of(context).pop();
      //   },
      // ),

      // Divider(height: 0),

      Spacer(),

      FutureBuilder(
          builder: (context, AsyncSnapshot<ConfigModel?> snapshot) {
            // Checking if future is resolved or not
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Container();
              } else if (snapshot.hasData) {
                final data = snapshot.data;
                return Column(
                  children: [
                    if (data?.appWhatsappUrl != null)
                      ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: Icon(Icons.whatsapp),
                        title: Text('Whatsapp Destek'),
                        subtitle: const Text(
                          "",
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () async {
                          await launchUrl(
                            Uri.parse(data!.appWhatsappUrl!),
                          );
                        },
                      ),
                    if (data?.appContactPhone != null || data!.appContactPhone.toString().trim().isNotEmpty)
                      ListTile(
                        visualDensity: VisualDensity.compact,
                        leading: Icon(Icons.phone_rounded),
                        title: Text(data?.appContactPhone ?? "İletişim Bilgisi Girilmemiş!"),
                        subtitle: Text(
                          "Aramak için tıklayın.",
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () async {
                          await launchUrl(Uri.parse(Platform.isIOS
                              ? 'tel://${data?.appContactPhone}'
                              : 'tel:${data?.appContactPhone}'));
                        },
                      ),
                  ],
                );
              }
            }

            return Center(child: Container());
          },
          future: fetchConfig()),
      SizedBox(height: 20)
    ]),
  );
}
