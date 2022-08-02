import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PreferredSizeWidget CustomAppBar(BuildContext context, IconData leadingIcon, String title) {
  return AppBar(
    surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
    automaticallyImplyLeading: false,
    elevation: 0.8,
    titleSpacing: 10,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: true,
    ),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    toolbarHeight: 70,
    title: Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Icon(leadingIcon, color: Colors.black),
        ),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ],
    ),
  );
}