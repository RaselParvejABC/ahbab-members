import '../../services/firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'past_yearly_savings.dart';

class PastYearlySavingsScreen extends StatelessWidget {
  const PastYearlySavingsScreen({Key? key}) : super(key: key);

  static get routeName => 'PastYearlySavingsScreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.3,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/login_background.jpg'),
            ),
          ),
          child: FutureBuilder(
            future: getDocumentSnapshotUsingSharedPreferences(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return const Text('ইন্টারনেট সংযোগ চেক করে আবার চেষ্টা করুন।');
              }
              if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                return SingleChildScrollView(
                  child: PastYearlySavings(snapshot.data as DocumentSnapshot),
                );
              }
              return const GFLoader();
            },
          ),
        ),
      ),
    );
  }
}
