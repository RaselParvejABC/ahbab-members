import '../../services/authentication/authentication.dart';

import '../../services/cryptography/cryptography.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeMyPasswordScreen extends StatefulWidget {
  static get routeName => "ChangeMyPasswordScreen";
  const ChangeMyPasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangeMyPasswordScreenState createState() => _ChangeMyPasswordScreenState();
}

class _ChangeMyPasswordScreenState extends State<ChangeMyPasswordScreen> {
  late String currentPasswordHash, newPassword;
  late DocumentSnapshot user;

  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordVerifyController = TextEditingController();

  Future<bool> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username')!;
    user = await FirebaseFirestore.instance.collection('members').doc(username).get();
    currentPasswordHash = user.get('passwordHash');
    return await isSavedSessionKeyValid();
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: FutureBuilder(
                    future: _getData(),
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
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        if(snapshot.data == false){
                          Navigator.of(context).pushReplacementNamed('LogInScreen');
                        }
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                'পাসওয়ার্ড পরিবর্তন করুন',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextFormField(
                                controller: _currentPasswordController,
                                decoration: const InputDecoration(
                                  labelText: 'বর্তমান পাসওয়ার্ড',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'বর্তমান পাসওয়ার্ড লিখেননি।';
                                  }
                                  if (getSHA256Hash(value) != currentPasswordHash) {
                                    return 'বর্তমান পাসওয়ার্ড ভুল লিখেছেন।';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _newPasswordController,
                                decoration: const InputDecoration(
                                  labelText: 'নতুন পাসওয়ার্ড',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'নতুন পাসওয়ার্ড লিখেননি।';
                                  }
                                  if (value.length < 8) {
                                    return 'কমপক্ষে আট ক্যারাক্টারের পাসওয়ার্ড লিখুন।';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _newPasswordVerifyController,
                                decoration: const InputDecoration(
                                  labelText: 'নতুন পাসওয়ার্ড আরেকবার লিখুন।',
                                ),
                                validator: (value) {
                                  if (value != _newPasswordController.text) {
                                    return 'মিলছে না।';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 32.0,
                              ),
                              ElevatedButton(
                                onPressed: () async{
                                  if(!_formKey.currentState!.validate()){
                                    return;
                                  }

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text(
                                          'দয়া করে কিছুক্ষণ অপেক্ষা করুন।',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: SizedBox(
                                          height: 40.0,
                                          child: GFLoader(
                                            type: GFLoaderType.circle,
                                            size: GFSize.SMALL,
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                  user.reference.update({
                                    'passwordHash' : getSHA256Hash(_newPasswordController.text),
                                    'sessionKeys' : [],
                                  }).then((value) async{
                                    Navigator.of(context).pop();
                                    await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'সফল',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: const Text('পাসওয়ার্ড পরিবর্তন হয়েছে। নতুন পাসওয়ার্ড দিয়ে লগিন করুন।'),
                                          actions: [
                                            TextButton(
                                              child: const Text('বেশ!'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                    Navigator.of(context).pushReplacementNamed('LogInScreen');
                                  },
                                      onError: (error) async {
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'ব্যর্থ',
                                                textAlign: TextAlign.center,
                                              ),
                                              content: const Text('পাসওয়ার্ড পরিবর্তন হয়নি। ইন্টারনেট সংযোগ চেক করে আবার চেষ্টা করুন।'),
                                              actions: [
                                                TextButton(
                                                  child: const Text('বেশ!'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      });
                                },
                                child: const Text('পরিবর্তন করুন'),
                              ),
                            ],
                          ),
                        );
                      }

                      return const GFLoader(
                        type: GFLoaderType.circle,
                        size: GFSize.LARGE,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
