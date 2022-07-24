import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget MyAppBar(String title, Icon? leadingIcon, BuildContext context,
    {bool automaticallyImplyLeading = false}) {
  return SliverAppBar(
    surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    elevation: 1,
    titleSpacing: 10,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemStatusBarContrastEnforced: true,
    ),
    shape: Border(
      bottom: BorderSide(width: 1.5, color: Colors.grey.shade200),
    ),
    pinned: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    toolbarHeight: 90,
    title: Row(
      children: [
        if (leadingIcon != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: leadingIcon,
          ),
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
