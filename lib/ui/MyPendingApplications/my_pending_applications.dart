import 'package:ahbabmembers/utilities/date_and_time.dart';

import '../dialogs/confirmation_dialog.dart';
import '../dialogs/inform_dialog.dart';

import '../../services/firestore/firestore.dart';
import '../../utilities/for_json.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

class MyPendingApplications extends StatefulWidget {
  static get routeName => "MyPendingApplications";
  const MyPendingApplications({Key? key}) : super(key: key);

  @override
  State<MyPendingApplications> createState() => _MyPendingApplicationsState();
}

class _MyPendingApplicationsState extends State<MyPendingApplications> {
  late final DocumentSnapshot member;

  late final List<DocumentSnapshot<Map<String, dynamic>>> pendingLoanApplications;

  late final List<DocumentSnapshot<Map<String, dynamic>>> members;

  Future getData() async{
    member = await getDocumentSnapshotUsingSharedPreferences();
    pendingLoanApplications = (await FirebaseFirestore.instance.collection('loanApplications')
        .where('applicantMemberID', isEqualTo: member.reference.id)
    .where('status', isEqualTo: 'pending')
    .orderBy('expectedTakeOutMonth')
    .get()).docs;
    members = (await FirebaseFirestore.instance.collection('members').get()).docs;
    return;
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
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot)  {
                  if(snapshot.hasError){
                    return const Text('কিছু একটা সমস্যা হয়েছে। পরে চেষ্টা করুন।');
                  }
                  if(snapshot.connectionState == ConnectionState.done){
                    if(pendingLoanApplications.isEmpty) {
                      return const Text('আপনার কোনো অমীমাংসিত লোন আবেদন নেই।');
                    }
                    return Column(
                      children: pendingLoanApplications.map((e) => getLoanWidget(e, context)).toList(),
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

  Widget getLoanWidget(DocumentSnapshot<Map<String, dynamic>> application, BuildContext context) {
    String title = 'ঋণের পরিমাণঃ ' + application.get('loanAmount').toString();
    String details = '\nপণ্যের বর্ণনাঃ ' + application.get('productDetails').toString();
    details += '\nলোনের মেয়াদঃ ' + application.get('loanPeriodInMonth').toString() + ' মাস';
    int expectedTakeOutMonth = int.tryParse(application.get('expectedTakeOutMonth').toString())!;
    details += '\nনিতে চাচ্ছেন ${expectedTakeOutMonth ~/ 100} সালের ${monthName(expectedTakeOutMonth % 100)} মাসে';
    List<String> bailsmen =  getListFromJSONArray(application.get('bailsmenMemberIDs'));
    DocumentSnapshot bailsmanOne = members.firstWhere((element) => element.reference.id == bailsmen.first);
    DocumentSnapshot bailsmanTwo = members.firstWhere((element) => element.reference.id == bailsmen.last);
    details += '\nপ্রথম জামিনদারঃ ' + bailsmanOne.get('nameInBanglaLetters').toString();
    details += ' (সদস্য নম্বর ' + bailsmanOne.reference.id + ', ';
    details += ' ফোন নাম্বার ' + bailsmanOne.get('phoneNumbers').toString() + ')';
    details += '\nদ্বিতীয় জামিনদারঃ ' + bailsmanTwo.get('nameInBanglaLetters').toString();
    details += ' (সদস্য নম্বর ' + bailsmanTwo.reference.id + ', ';
    details += ' ফোন নাম্বার ' + bailsmanTwo.get('phoneNumbers').toString() + ')';

    return GFAccordion(
      title: title,
      contentChild: Column(
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text('আবেদন ডিলিট করুন'),
            onPressed: () async {
              bool response =  await showConfirmationDialog(context, 'নিশ্চিত তো?', 'এই আবেদনটি ডিলিট করতে যাচ্ছেন।');
              if(response){
                application.reference.delete().then((value) async {
                  await showInformDialog(context, 'সফল', 'আবেদন ডিলিট হয়েছে।');
                  Navigator.of(context).pushReplacementNamed(MyPendingApplications.routeName);
                });
              }
            },
          ),
          Text(
            details,
          ),
        ],
      ),
    );
  }
}
