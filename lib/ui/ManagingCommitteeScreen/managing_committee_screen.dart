import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ManagingCommitteeScreen extends StatelessWidget {
  static get routeName => "ManagingCommitteeScreen";
  const ManagingCommitteeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.2,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/login_background.jpg'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('ahbabVariables').doc('committee').get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('ইন্টারনেট সংযোগ চেক করে আবার চেষ্টা করুন।');
                }
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  List<Map<String, dynamic>> committeeMembers =
                      ((snapshot.data as DocumentSnapshot).get('members') as List).map((e) => e as Map<String, dynamic>).toList();
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'পরিচালনা কমিটি',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Text(
                          'বামে-ডানে স্ক্রল করে দেখুন',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            child: DataTable(
                              columns: const [
                                DataColumn(
                                  label: SelectableText('নাম'),
                                ),
                                DataColumn(
                                  label: SelectableText('পদবী'),
                                ),
                                DataColumn(
                                  label: SelectableText('ফোন'),
                                ),
                              ],
                              rows: committeeMembers.map((member) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      SelectableText(member['name']),
                                    ),
                                    DataCell(
                                      SelectableText(member['designation']),
                                    ),
                                    DataCell(
                                      SelectableText(member['phone']),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const GFLoader();
              },
            ),
          ),
        ),
      ),
    );
  }
}
