import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoConnPage extends StatelessWidget {
  const NoConnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/noconn.json',
              width: 300,
            ),
            Text(
              "İnternete bağlanamadık.\nLütfen ağ ayarlarınızı kontrol edin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
