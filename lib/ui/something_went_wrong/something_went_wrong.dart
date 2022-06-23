import 'package:flutter/material.dart';

class SomethingWentWrongScreen extends StatelessWidget {
  const SomethingWentWrongScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/Something Went Wrong.png",
            fit: BoxFit.cover,
          ),
          const Positioned.fill(
            bottom: 50.0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'ইশ্‌!\nকিছু একটা সমস্যা হয়েছে।\nএ্যাপটি বন্ধ করে আবার চালু করুন।',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
