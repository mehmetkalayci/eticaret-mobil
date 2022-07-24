import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget MyDrawerMenu(BuildContext context) {

  return Drawer(
    child: Column(children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Image.asset(
            "assets/images/logo.png",
            height: 50,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      ListTile(
        minLeadingWidth: 20,
        leading: Icon(Icons.home_rounded),
        title: const Text('Anasayfa'),
        onTap: () {},
      ),
      Divider(height: 0),
      ListTile(
        minLeadingWidth: 20,
        leading: Icon(Icons.search_rounded),
        title: const Text('Ürün Ara'),
        onTap: () {},
      ),
      Divider(height: 0),
      ListTile(
        minLeadingWidth: 20,
        leading: Icon(Icons.shopping_basket_rounded),
        title: const Text('Sepet'),
        onTap: () {},
      ),
      Divider(height: 0),
      ListTile(
        minLeadingWidth: 20,
        leading: Icon(Icons.person_rounded),
        title: const Text('Hesabım'),
        onTap: () {},
      ),
      Divider(height: 0),
      ListTile(
        minLeadingWidth: 20,
        leading: Icon(Icons.discount_rounded),
        title: const Text('Bana Özel'),
        onTap: () {},
      ),
      Divider(height: 0),

      Spacer(),
      Divider(height: 0),
      ListTile(
        leading: Icon(Icons.phone_rounded),
        title: Text('+90 555 444 33 22'),
        subtitle: Text("Aramak için tıklayın."),
        onTap: () async {
          await launchUrl(Uri.parse('tel:+905346098067'));
        },
      ),
      Divider(height: 0),

      SizedBox(height: 20)
    ]),
  );
}
