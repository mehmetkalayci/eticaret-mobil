import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

Widget MyErrorWidget(BuildContext context) {
  return Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 10,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemStatusBarContrastEnforced: true,
          ),
          pinned: true,
          backgroundColor: Theme.of(context).primaryColor,
          //Theme.of(context).scaffoldBackgroundColor,
          actions: [
            MaterialButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              child: Image.asset(
                "assets/images/icons/menu-burger.png",
                height: 32,
                color: Colors.white,
              ),
              elevation: 0,
              disabledElevation: 0,
              hoverElevation: 0,
              highlightElevation: 0,
              focusElevation: 0,
              splashColor: Colors.white10,
              highlightColor: Colors.white10,
              padding: EdgeInsets.zero,
            ),
          ],
          toolbarHeight: 90,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lotties/error_cat.json'),
              SizedBox(height: 10),
              Text(
                "Hata oluştu!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
