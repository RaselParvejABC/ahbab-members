import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MyInformationScreen extends StatelessWidget {
  static get routeName => "MyInformationScreen";
  const MyInformationScreen({Key? key}) : super(key: key);


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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: getDocumentSnapshotUsingSharedPreferences(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      'কিছু একটা সমস্যা হয়েছে। এ্যাপ বন্ধ করে ইন্টারনেট সংযোগ চেক করে আবার চালু করুন।',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }

                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                    DocumentSnapshot memberDocSnap = snapshot.data as DocumentSnapshot;
                    return Table(
                      border: TableBorder.all(
                        borderRadius: const BorderRadius.all(Radius.elliptical(3, 4)),
                      ),
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        1 : FlexColumnWidth(2.0),
                      },
                      children: [
                        TableRow(children: getTableRowCells('সদস্য নম্বর', memberDocSnap.reference.id)),
                        TableRow(children: getTableRowCells('নির্ধারিত মাসিক চাঁদা', memberDocSnap.get('monthlyFixedAmount').toString())),
                        TableRow(children: getTableRowCells('নাম (ইংরেজি)', memberDocSnap.get('nameInEnglishLetters').toString())),
                        TableRow(children: getTableRowCells('নাম (বাংলা)', memberDocSnap.get('nameInBanglaLetters').toString())),
                        TableRow(children: getTableRowCells('তড়িৎডাক', memberDocSnap.get('emailAddress').toString())),
                        TableRow(children: getTableRowCells('দূরালাপন', memberDocSnap.get('phoneNumbers').toString().split(RegExp(r"\s+")).join("\n"))),
                        TableRow(children: getTableRowCells('পাসপোর্ট নম্বর', memberDocSnap.get('passportNumber').toString())),
                        TableRow(children: getTableRowCells('কাতার আইডি', memberDocSnap.get('QID').toString())),
                        TableRow(children: getTableRowCells('এনআইডি', memberDocSnap.get('NID').toString())),
                        TableRow(children: getTableRowCells('ঠিকানা (কাতার)', memberDocSnap.get('addressInQatar').toString())),
                        TableRow(children: getTableRowCells('ঠিকানা (বাংলাদেশ)', memberDocSnap.get('addressInBangladesh').toString())),
                        TableRow(children: getTableRowCells('নমিনি', memberDocSnap.get('nomineeData').toString())),
                        TableRow(children: getTableRowCells('রেফারার', memberDocSnap.get('refererData').toString())),
                      ],
                    );
                  }

                  return const GFLoader();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getTableRowCells(String key, String value){
    return [
      getTableCell(key),
      getTableCell(value),
    ];
  }

  Widget getTableCell(String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SelectableText(content),
    );
  }
}
