import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';

import '../../../../services/firestore/firestore.dart';

class BalanceWidget extends StatefulWidget {
  final DocumentSnapshot memberDocSnap;
  const BalanceWidget(this.memberDocSnap, {Key? key}) : super(key: key);

  @override
  _BalanceWidgetState createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: 'SolaimanLipi',
        color: Colors.black,
        fontSize: 16.0,
        //fontWeight: FontWeight.bold,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Balance',
            textAlign: TextAlign.center,
          ),
          StreamBuilder<int>(
            stream: calculateTotalBalance(widget.memberDocSnap),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Icon(
                  FontAwesome5Solid.magnet,
                );
              }
              if (snapshot.connectionState != ConnectionState.done) {
                return Text(snapshot.data.toString());
              }
              return const GFLoader(
                type: GFLoaderType.square,
              );
            },
          ),
        ],
      ),
    );
  }
}
