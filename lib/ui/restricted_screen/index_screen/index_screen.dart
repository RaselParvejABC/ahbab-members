import '../../MyPendingApplications/my_pending_applications.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';

import '../../ChangeMyPasswordScreen/change_my_password_screen.dart';
import '../../ManagingCommitteeScreen/managing_committee_screen.dart';
import '../../MyInformation/my_information.dart';
import '../../MyLoans/my_loans.dart';
import '../../PrinciplesScreen/principles_screen.dart';
import '../../ApplicationForLoanScreen/application_for_loan_screen.dart';
import '../../notices_screen/notices.dart';
import 'components/user_banner.dart';
import '../../past_monthly_savings/past_monthly_savings_screen.dart';
import '../../past_yearly_savings/past_yearly_savings_screen.dart';

class IndexScreen extends StatelessWidget {
  final List<Map<String, String>> screens = [
    {
      'label': 'নোটিশ বোর্ড',
      'routeName': NoticesScreen.routeName,
    },
    {
      'label': 'মাসিক সঞ্চয়',
      'routeName': PastMonthlySavingsScreen.routeName,
    },
    {
      'label': 'বার্ষিক সঞ্চয়',
      'routeName': PastYearlySavingsScreen.routeName,
    },
    {
      'label': 'আমার লোন',
      'routeName': MyLoansScreen.routeName,
    },
    {
      'label': 'অমীমাংসিত আবেদনসমূহ',
      'routeName': MyPendingApplications.routeName,
    },
    {
      'label': 'লোনের জন্য আবেদন',
      'routeName': ApplicationForLoanScreen.routeName,
    },
    {
      'label': 'আমার তথ্য',
      'routeName': MyInformationScreen.routeName,
    },
    {
      'label': 'পাসওয়ার্ড পরিবর্তন',
      'routeName': ChangeMyPasswordScreen.routeName,
    },
    {
      'label': 'পরিচালনা কমিটি',
      'routeName': ManagingCommitteeScreen.routeName,
    },
    {
      'label': 'গঠনতন্ত্র',
      'routeName': PrinciplesScreen.routeName,
    },
  ];

  final DocumentSnapshot memberDocSnapshot;
  IndexScreen(
    this.memberDocSnapshot, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.3,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/login_background.jpg'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UserBanner(memberDocSnapshot),
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.all(8.0),
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    children: screens.map((e) {
                      return getGridCard(e, context);
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getGridCard(Map<String, String> screen, BuildContext context) {
    String label = screen['label']!;
    return GFButton(
      color: GFColors.FOCUS,
      type: GFButtonType.solid,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'SolaimanLipi',
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(screen['routeName']!);
      },
    );
  }
}
