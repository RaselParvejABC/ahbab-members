import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';


import '../../services/firestore/firestore.dart';
import '../something_went_wrong/something_went_wrong.dart';
import 'index_screen/index_screen.dart';

class RestrictedScreen extends StatefulWidget {
  static String routeName = 'RestrictedScreen';
  const RestrictedScreen({Key? key}) : super(key: key);

  @override
  _RestrictedScreenState createState() => _RestrictedScreenState();
}

class _RestrictedScreenState extends State<RestrictedScreen> {
  Future<DocumentSnapshot> memberDocSnapshot = getDocumentSnapshotUsingSharedPreferences();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: memberDocSnapshot,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const SomethingWentWrongScreen();
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return IndexScreen(snapshot.data as DocumentSnapshot);
        }
        return const GFLoader(
            type: GFLoaderType.square
        );
      },
    );
  }
}
