import 'package:ahbabmembers/services/authentication/authentication.dart';
import 'package:ahbabmembers/ui/dialogs/wait_dialog.dart';
import 'package:ahbabmembers/ui/log_in_screen/log_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'balance.dart';

class UserBanner extends StatelessWidget {
  final DocumentSnapshot memberDocSnapshot;
  const UserBanner(
    this.memberDocSnapshot, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        const Text(
          'আস্‌-সালামু \'আলাইকুম ওয়া রাহ্‌মাতুল্লাহি ওয়া বারাকাতুহু',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.elliptical(4.0, 3.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0xAA000000),
                blurRadius: 1.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          height: 100.0,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GFAvatar(
                    backgroundImage: NetworkImage(
                      memberDocSnapshot.get('profileImageLink'),
                    ),
                    shape: GFAvatarShape.circle,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: 'SolaimanLipi',
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(memberDocSnapshot.get('nameInBanglaLetters')),
                          Text('সদস্য নম্বরঃ ' + memberDocSnapshot.reference.id),
                          if ((memberDocSnapshot.get('QID') as String) != "")
                            Text('QID: ' + memberDocSnapshot.get('QID'))
                          else
                            Text('NID: ' + memberDocSnapshot.get('NID')),
                          Text('Phone: ' + memberDocSnapshot.get('phoneNumbers').toString().split(RegExp(r"\s+")).first),
                        ],
                      ),
                    ),
                  ),
                  BalanceWidget(memberDocSnapshot),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0).copyWith(top: 0.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text('লগ আউট'),
                onPressed: () async {
                  showWaitDialog(context);
                  await logOutCleanUp();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(LogInScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
