import 'package:ahbabmembers/ui/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

import 'log_in_form.dart';
import '../../services/authentication/authentication.dart';
import '../restricted_screen/restricted_screen.dart';
import '../something_went_wrong/something_went_wrong.dart';


class LogInScreen extends StatelessWidget {
  static String routeName = 'LogInScreen';
  const LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> _isSavedSessionKeyValid = isSavedSessionKeyValid();
    return FutureBuilder(
      future: _isSavedSessionKeyValid,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const SomethingWentWrongScreen();
        }
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          if(snapshot.data == true) {
            return const RestrictedScreen();
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/login_background.jpg',
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ahbab_logo.png',
                          width: 100.0,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF7900FF),
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                          margin: const EdgeInsets.all(16.0).copyWith(bottom: 0.0),
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                          child: const Text(
                            'আল-আহবাব সোসাইটি',
                            style: TextStyle(
                              fontFamily: 'SolaimanLipi',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const LogInForm(),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          );
        }
        return const SplashScreen();
      },
    );

  }
}
