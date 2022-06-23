import 'package:ahbabmembers/ui/ApplicationForLoanScreen/expected_take_out_month.dart';
import 'package:provider/provider.dart';
import '../../utilities/date_and_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:regexpattern/regexpattern.dart';

import '../dialogs/confirmation_dialog.dart';
import '../dialogs/inform_dialog.dart';
import '../dialogs/wait_dialog.dart';

class ApplicationForLoanScreen extends StatefulWidget {
  static get routeName => "ApplicationForLoanScreen";
  const ApplicationForLoanScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationForLoanScreen> createState() => _ApplicationForLoanScreenState();
}

class _ApplicationForLoanScreenState extends State<ApplicationForLoanScreen> {
  late final String memberRegistrationNumber;

  late final List<DocumentSnapshot<Map<String, dynamic>>> members;

  late final DocumentSnapshot applicant;

  final _formKey = GlobalKey<FormState>();

  final _loanAmountController = TextEditingController();

  final _productDetailsController = TextEditingController();

  final _loanPeriodController = TextEditingController();

  final _bailsmanOneController = TextEditingController();

  final _bailsmanTwoController = TextEditingController();

  Future<bool> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    memberRegistrationNumber = prefs.getString('username')!;
    members = (await FirebaseFirestore.instance.collection('members').get()).docs;
    applicant = members.firstWhere((element) => element.reference.id == memberRegistrationNumber);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ExpectedTakeOutMonth(),
        ),
      ],
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
            padding: const EdgeInsets.all(32.0).copyWith(top: 64.0),
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      'কিছু একটা সমস্যা হয়েছে। এ্যাপ বন্ধ করে ইন্টারনেট সংযোগ করে চেক করে আবার চেষ্টা করুন।',
                    );
                  }

                  DateTime? _expectedTakeOutMonth = context.watch<ExpectedTakeOutMonth>().getTime;
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontFamily: 'SolaimanLipi',
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              'ঋণের জন্য আবেদন',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              'ঋণপ্রার্থীর সদস্য নম্বরঃ ' + memberRegistrationNumber,
                            ),
                            Text(
                              'ঋণপ্রার্থীর নামঃ ' + applicant.get('nameInBanglaLetters').toString(),
                            ),
                            Text(
                              'ঋণপ্রার্থীর মোবাইল নাম্বারঃ ' + applicant.get('phoneNumbers').toString(),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _loanAmountController,
                              decoration: const InputDecoration(
                                labelText: 'ঋণের কাঙ্ক্ষিত পরিমাণ',
                              ),
                              validator: (value) {
                                value = value?.trim();
                                if (value == null || value.isEmpty) {
                                  return 'ঋণের কাঙ্ক্ষিত পরিমাণ লিখেননি।';
                                }
                                _loanAmountController.text = value;
                                if (!value.isNumeric()) {
                                  return 'এই ঘরে শুধু ইংরেজি ডিজিট বসবে।';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _productDetailsController,
                              minLines: 2,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                labelText: 'পণ্যের বর্ণনা লিখুন (অনধিক ২০০ ক্যারাক্টারে)',
                              ),
                              validator: (value) {
                                value = value?.trim();
                                if (value == null || value.isEmpty) {
                                  return 'পণ্যের বর্ণনা লিখেননি।';
                                }
                                _productDetailsController.text = value;
                                if (value.length > 200) {
                                  return '২০০ ক্যারাক্টারের বেশি লিখে ফেলেছেন।';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _loanPeriodController,
                              decoration: const InputDecoration(
                                labelText: 'কয় মাস মেয়াদী ঋণ?',
                              ),
                              validator: (value) {
                                value = value?.trim();
                                if (value == null || value.isEmpty) {
                                  return 'ঋণের মেয়াদ লিখেননি।';
                                }
                                _loanPeriodController.text = value;
                                if (!value.isNumeric()) {
                                  return 'এই ঘরে শুধু ইংরেজি ডিজিট বসবে।';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            GFButton(
                              size: GFSize.LARGE,
                              type: GFButtonType.outline2x,
                              child: const Text(
                                'কোন মাসে ঋণটি নিতে চাচ্ছেন, তা বাছাই করুন',
                                style: TextStyle(
                                  fontFamily: 'SolaimanLipi',
                                ),
                              ),
                              onPressed: () async {
                                DateTime? selectedMonth = await showMonthPicker(
                                  context: context,
                                  initialDate: _expectedTakeOutMonth ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                );
                                if(selectedMonth != null){
                                  context.read<ExpectedTakeOutMonth>().setTime = selectedMonth;
                                }
                              },
                            ),
                            if(_expectedTakeOutMonth != null) Text(
                              'ঋণটি ${_expectedTakeOutMonth.year.toString()} সালের ${monthName(_expectedTakeOutMonth.month)} মাসে নিতে চাচ্ছেন।',
                              style: const TextStyle(
                                fontFamily: 'SolaimanLipi',
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _bailsmanOneController,
                              decoration: const InputDecoration(
                                labelText: 'প্রথম জামিনদারের সদস্য নম্বর',
                              ),
                              validator: (value) {
                                value = value?.trim();
                                if (value == null || value.isEmpty) {
                                  return 'প্রথম জামিনদারের সদস্য নম্বর লিখেননি।';
                                }
                                _bailsmanOneController.text = value;
                                if (!value.isNumeric()) {
                                  return 'এই ঘরে শুধু ইংরেজি ডিজিট বসবে।';
                                }
                                if (!members.any((element) => element.reference.id == value)) {
                                  return 'এই সদস্য নাম্বারের কোনো সদস্য নেই।';
                                }
                                if (value == memberRegistrationNumber) {
                                  return 'আপনার ঋণের জামিনদার আপনি হতে পারেন না।';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _bailsmanTwoController,
                              decoration: const InputDecoration(
                                labelText: 'দ্বিতীয় জামিনদারের সদস্য নম্বর',
                              ),
                              validator: (value) {
                                value = value?.trim();
                                if (value == null || value.isEmpty) {
                                  return 'দ্বিতীয় জামিনদারের সদস্য নম্বর লিখেননি।';
                                }
                                _bailsmanTwoController.text = value;
                                if (!value.isNumeric()) {
                                  return 'এই ঘরে শুধু ইংরেজি ডিজিট বসবে।';
                                }
                                if (!members.any((element) => element.reference.id == value)) {
                                  return 'এই সদস্য নাম্বারের কোনো সদস্য নেই।';
                                }
                                if (value == memberRegistrationNumber) {
                                  return 'আপনার ঋণের জামিনদার আপনি হতে পারেন না।';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            ElevatedButton(
                              child: const Text('সাবমিট করুন'),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate() || _expectedTakeOutMonth == null) {
                                  return;
                                }



                                String confirmationMessage = 'ঋণপ্রার্থীর সদস্য নম্বরঃ ' + memberRegistrationNumber;
                                confirmationMessage += '\nঋণের পরিমাণঃ ' + _loanAmountController.text;
                                confirmationMessage += '\nপণ্যের বর্ণনাঃ ' + _productDetailsController.text;
                                confirmationMessage += '\nলোনের মেয়াদঃ ' + _loanPeriodController.text + ' মাস';
                                confirmationMessage += '\nনিতে চাচ্ছেন ${_expectedTakeOutMonth.year.toString()} সালের ${monthName(_expectedTakeOutMonth.month)} মাসে';
                                DocumentSnapshot bailsmanOne = members.firstWhere((element) => element.reference.id == _bailsmanOneController.text);
                                DocumentSnapshot bailsmanTwo = members.firstWhere((element) => element.reference.id == _bailsmanTwoController.text);
                                confirmationMessage += '\nপ্রথম জামিনদারঃ ' + bailsmanOne.get('nameInBanglaLetters').toString();
                                confirmationMessage += ' (সদস্য নম্বর ' + bailsmanOne.reference.id + ', ';
                                confirmationMessage += ' ফোন নাম্বার ' + bailsmanOne.get('phoneNumbers').toString() + ')';
                                confirmationMessage += '\nদ্বিতীয় জামিনদারঃ ' + bailsmanTwo.get('nameInBanglaLetters').toString();
                                confirmationMessage += ' (সদস্য নম্বর ' + bailsmanTwo.reference.id + ', ';
                                confirmationMessage += ' ফোন নাম্বার ' + bailsmanTwo.get('phoneNumbers').toString() + ')';
                                bool proceed = await showConfirmationDialog(context, 'ভালোভাবে দেখে নিন', confirmationMessage);
                                if (!proceed) {
                                  return;
                                }
                                showWaitDialog(context);

                                Map<String, dynamic> data = {};
                                DateTime now = DateTime.now();
                                data['status'] = 'pending';
                                data['submissionTimestamp'] = now.millisecondsSinceEpoch;
                                data['applicantMemberID'] = memberRegistrationNumber;
                                data['loanAmount'] = _loanAmountController.text;
                                data['productDetails'] = _productDetailsController.text;
                                data['loanPeriodInMonth'] = _loanPeriodController.text;
                                data['expectedTakeOutMonth'] = _expectedTakeOutMonth.year.toString() + _expectedTakeOutMonth.month.toString().padLeft(2, '0');
                                data['bailsmenMemberIDs'] = [_bailsmanOneController.text, _bailsmanTwoController.text];
                                data['timeline'] = ['Submitted on ' + now.toString()];

                                FirebaseFirestore.instance
                                    .collection('loanApplications')
                                    .doc(memberRegistrationNumber + now.millisecondsSinceEpoch.toString())
                                    .set(data)
                                    .then((value) {
                                  Navigator.of(context).pop();
                                  showInformDialog(context, 'সফল', 'আবেদন সাবমিট হয়েছে।');
                                  _formKey.currentState!.reset();
                                }, onError: (error) {
                                  Navigator.of(context).pop();
                                  showInformDialog(context, 'ব্যর্থ', 'আবেদন সাবমিট হয়নি। ইন্টারনেট সংযোগ চেক করে আবার চেষ্টা করুন।');
                                });
                              },
                            ),
                          ],
                        ),
                      ),
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
}
