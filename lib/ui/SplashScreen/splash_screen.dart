import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ahbab_logo.png',
              width: 150.0,
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Text(
              'শরীয়াহভিত্তিক সঞ্চয় করি,\nসুদমুক্ত সমাজ গড়ি',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SolaimanLipi',
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
