import '../../utilities/for_json.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticesScreen extends StatelessWidget {
  static get routeName => 'Notices';


  const NoticesScreen({Key? key}) : super(key: key);

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberRegistrationNumber = prefs.getString('username')!;
    return FirebaseFirestore.instance.collection('notices').where('to', arrayContainsAny: ['1000', memberRegistrationNumber]).orderBy('timestamp', descending: true,).snapshots();
  }

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
                future: getData(),
                builder: (context, snapshot){
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
                    return Notices(snapshot.data as Stream<QuerySnapshot<Map<String, dynamic>>>);
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
}

class Notices extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> noticesStream;
  const Notices(this.noticesStream, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: noticesStream,
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
        if(snapshot.hasData){
          List<Map<String, dynamic>> notices = (snapshot.data as QuerySnapshot<Map<String, dynamic>>).docs.map((e) => e.data()).toList();
          return Column(
            children: [
              const Text(
                'নোটিশ বোর্ড',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...notices.map((e) => getNoticeWidget(e)).toList(),
            ],

          );
        }
        
        return const GFLoader();
      },
    );
  }

  Widget getNoticeWidget(Map<String, dynamic> notice){
    List<String> toMembers = getListFromJSONArray(notice['to']);
    late String toMembersString;
    if(toMembers.contains('1000')){
      toMembersString = 'All';
    } else {
      toMembersString = toMembers.join(", ");
    }
    return GFAccordion(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      titleChild: SelectableText(
        notice['title'],
      ),
      contentChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            'By ${notice['byAdmin']} at ${DateTime.fromMillisecondsSinceEpoch(int.parse(notice['timestamp']))}',
          ),
          SelectableText(
            'To Member(s): $toMembersString',
          ),
          SelectableText(
            notice['body'],
          ),
        ],
      ),
    );
  }
}

