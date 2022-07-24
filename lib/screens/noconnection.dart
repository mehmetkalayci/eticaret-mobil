import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage({Key? key}) : super(key: key);

  @override
  State<NoConnectionPage> createState() => _NoConnectionPageState();
}

class _NoConnectionPageState extends State<NoConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(children: [
          Lottie.asset(
            'assets/lotties/no_internet_animation.json',
            height: 400,
          ),
          Text(
            "İnternete bağlanamadık.\nLütfen ağ ayarlarınızı kontrol edin.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ]),
      ),
    );
  }
}
