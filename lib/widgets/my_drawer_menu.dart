import 'package:badges/badges.dart';
import 'package:ecommerce_mobile/providers/auth_provider.dart';
import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:ecommerce_mobile/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Widget MyDrawerMenu(BuildContext context) {
    MenuProvider menu = Provider.of<MenuProvider>(context);
    CartProvider cart = Provider.of<CartProvider>(context);
    AuthProvider auth = Provider.of<AuthProvider>(context);

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
      // Divider(height: 0),
      // ListTile(
      //   minLeadingWidth: 20,
      //   leading: Icon(Icons.person_rounded),
      //   title: const Text('Hesabım'),
      //   onTap: () {
      //     menu.setMenuIndex(2);
      //     Navigator.of(context).pop();
      //   },
      // ),
      // Divider(height: 0),
      // ListTile(
      //   minLeadingWidth: 20,
      //   leading: Icon(Icons.discount_rounded),
      //   title: const Text('Bana Özel'),
      //   onTap: () {},
      // ),
      Divider(height: 0),
      if (!auth.getIsLoggedIn)
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
      ListTile(
        minLeadingWidth: 20,
        leading: Icon(Icons.discount_rounded),
        title: const Text('Giriş Yap'),
        onTap: () {
          menu.setCurrentPage(3);
          Navigator.of(context).pop();
        },
      ),
      Divider(height: 0),
      Spacer(),
      Divider(height: 0),
      ListTile(
        visualDensity: VisualDensity.compact,
        leading: Icon(Icons.phone_rounded),
        title: Text('+90-553-627-0909'),
        subtitle: Text(
          "Aramak için tıklayın.",
          style: TextStyle(fontSize: 14),
        ),
        onTap: () async {
          await launchUrl(Uri.parse('tel:+905536270909'));
        },
      ),
      Divider(height: 0),
      SizedBox(height: 20)
    ]),
  );
}
