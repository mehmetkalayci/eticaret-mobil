import 'package:flutter/material.dart';

Widget CustomTitle(BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10, top:10),
    child: Text(
      title,
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    ),
  );
}