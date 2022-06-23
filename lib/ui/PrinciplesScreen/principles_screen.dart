import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

class PrinciplesScreen extends StatelessWidget {
  static get routeName => 'PrinciplesScreen';
  const PrinciplesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.1,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/login_background.jpg'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('ahbabVariables').doc('principles').get(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return const Text('ইন্টারনেট সংযোগ চেক করে আবার চেষ্টা করুন।');
                }
                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                  String title = (snapshot.data as DocumentSnapshot).get('title').toString();
                  String principles = (snapshot.data as DocumentSnapshot).get('principles').toString();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SelectableText(
                          title,
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SelectableText(
                          principles,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const GFLoader();

              },
            ),
          ),
        ),
      ),
    );
  }
}
