import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:regexpattern/regexpattern.dart';

import '../../services/authentication/authentication.dart';
import '../dialogs/wait_dialog.dart';
import '../../services/firestore/firestore.dart';
import '../dialogs/inform_dialog.dart';
import '../../services/cryptography/cryptography.dart';
import '../restricted_screen/restricted_screen.dart';
import '../../utilities/for_json.dart';
import '../../services/internet_connection/internet_connection.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({Key? key}) : super(key: key);

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final _logInFormKey = GlobalKey<FormState>();
  final _memberRegistrationNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.all(32.0).copyWith(top: 0.0),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _logInFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _memberRegistrationNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(FontAwesome5Solid.user_shield),
                hintText: 'সদস্য নম্বর লিখুন।',
              ),
              validator: (value) {
                value = value?.trim();
                if (value == null || value.isEmpty) {
                  return 'সদস্য নম্বর লিখেননি।';
                }
                _memberRegistrationNumberController.text = value;
                if (!value.isNumeric()) {
                  return 'সদস্য নম্বরে শুধু ইংরেজি ডিজিট থাকবে।';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                icon: Icon(FontAwesome5Solid.key),
                hintText: 'পাসওয়ার্ড',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'পাসওয়ার্ড লিখেননি।';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              child: const Text('লগ ইন'),
              onPressed: () async {

                //await passwordToPasswordHash();
                //return;

                if(!_logInFormKey.currentState!.validate()){
                  return;
                }

                if(!(await isConnectedToInternet())) {
                  await showInformDialog(context, 'ইন্টারনেট সমস্যা', 'ইন্টারনেটে যুক্ত হোন।');
                  return;
                }
                showWaitDialog(context);
                DocumentSnapshot memberDocSnapshot = await getDocumentSnapshot('members', _memberRegistrationNumberController.text);
                if(!memberDocSnapshot.exists) {
                  Navigator.of(context).pop();
                  await showInformDialog(context, 'ভুল সদস্য নম্বর', 'এই সদস্য নম্বরের কোনো সদস্য নেই।');
                  return;
                }
                if(memberDocSnapshot.get('passwordHash').toString() != getSHA256Hash(_passwordController.text)) {
                  Navigator.of(context).pop();
                  await showInformDialog(context, 'পাসওয়ার্ড', 'পাসওয়ার্ড ভুল লিখেছেন।');
                  return;
                }
                String sessionKey = getSHA256Hash(
                    memberDocSnapshot.reference.id
                        + _passwordController.text
                        + DateTime.now().toString()
                );


                List<String> sessionKeys = getListFromJSONArray(
                  getValueFromDocumentSnapshot(memberDocSnapshot, 'sessionKeys')
                );

                sessionKeys.add(sessionKey);

                try{
                  memberDocSnapshot.reference.update({
                    'sessionKeys' : sessionKeys,
                  });
                } catch(error){
                  Navigator.of(context).pop();
                  await showInformDialog(context, 'ইন্টারনেট সমস্যা', 'ইন্টারনেটে যুক্ত হোন।');
                  return;
                }

                await saveAuthenticationCredentialsOnSharedPreference(
                    memberDocSnapshot.reference.id, sessionKey
                );

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(RestrictedScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
