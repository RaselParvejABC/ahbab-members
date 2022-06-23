import '../../services/firestore/firestore.dart';
import '../../utilities/for_json.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

class MyLoansScreen extends StatefulWidget {
  static get routeName => "MyLoansScreen";
  const MyLoansScreen({Key? key}) : super(key: key);

  @override
  State<MyLoansScreen> createState() => _MyLoansScreenState();
}

class _MyLoansScreenState extends State<MyLoansScreen> {
  late final DocumentSnapshot member;

  late final List<DocumentSnapshot<Map<String, dynamic>>> myLoans;

  late final List<DocumentSnapshot<Map<String, dynamic>>> members;

  Future getData() async{
    member = await getDocumentSnapshotUsingSharedPreferences();
    myLoans = (await FirebaseFirestore.instance.collection('loanApplications')
        .where('applicantMemberID', isEqualTo: member.reference.id)
        .where('status', isEqualTo: 'accepted')
        .orderBy('dueTimestamp')
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
                    if(myLoans.isEmpty) {
                      return const Text('আপনার কোনো চলমান ঋণ নেই।');
                    }
                    return Column(
                      children: myLoans.map((e) => getLoanWidget(e, context)).toList(),
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
    details += '\nঋণ নিয়েছেন ${application.get('takeOutTimestamp').toString()} তারিখে';
    details += '\nপরিশোধ করবেন ${application.get('dueTimestamp').toString()} তারিখে';
    details += '\nপরিশোধ করবেন ${application.get('paybackAmount').toString()}';
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
      contentChild: Text(
        details,
      ),
    );
  }
}
