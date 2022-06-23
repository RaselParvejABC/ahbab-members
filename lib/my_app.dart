import 'package:ahbabmembers/ui/MyPendingApplications/my_pending_applications.dart';
import 'package:flutter/material.dart';

import 'ui/log_in_screen/log_in_screen.dart';
import 'ui/past_yearly_savings/past_yearly_savings_screen.dart';
import 'ui/restricted_screen/restricted_screen.dart';
import 'ui/ChangeMyPasswordScreen/change_my_password_screen.dart';
import 'ui/ManagingCommitteeScreen/managing_committee_screen.dart';
import 'ui/PrinciplesScreen/principles_screen.dart';
import 'ui/past_monthly_savings/past_monthly_savings_screen.dart';
import 'ui/MyInformation/my_information.dart';
import 'ui/notices_screen/notices.dart';
import 'ui/ApplicationForLoanScreen/application_for_loan_screen.dart';
import 'ui/MyLoans/my_loans.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Ahbab Society',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SolaimanLipi',
      ),
      home: const Scaffold(
        body: LogInScreen(),
      ),
      onGenerateRoute: (settings) {
        if(settings.name == LogInScreen.routeName) {
          return MaterialPageRoute(
              builder: (context) {
                return const Scaffold(
                  body: LogInScreen(),
                );
              }
          );
        }
        if(settings.name == RestrictedScreen.routeName) {
          return MaterialPageRoute(
              builder: (context) {
                return const RestrictedScreen();
              }
          );
        }
        if(settings.name == PastMonthlySavingsScreen.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return const PastMonthlySavingsScreen();
              }
          );
        }
        if(settings.name == PastYearlySavingsScreen.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return const PastYearlySavingsScreen();
              }
          );
        }
        if(settings.name == PrinciplesScreen.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return const PrinciplesScreen();
              }
          );
        }
        if(settings.name == ManagingCommitteeScreen.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return const ManagingCommitteeScreen();
              }
          );
        }
        if(settings.name == ChangeMyPasswordScreen.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return const ChangeMyPasswordScreen();
              }
          );
        }
        if(settings.name == MyInformationScreen.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return const MyInformationScreen();
              }
          );
        }
        if(settings.name == NoticesScreen.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return const NoticesScreen();
              }
          );
        }
        if(settings.name == ApplicationForLoanScreen.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return ApplicationForLoanScreen();
              }
          );
        }
        if(settings.name == MyLoansScreen.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return const MyLoansScreen();
              }
          );
        }
        if(settings.name == MyPendingApplications.routeName){
          return MaterialPageRoute(
              builder: (context) {
                return MyPendingApplications();
              }
          );
        }
      },
    );
  }
}
