import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firestore/firestore.dart';
import '../../utilities/for_json.dart';

Future saveAuthenticationCredentialsOnSharedPreference(String username, String sessionKey) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
  await prefs.setString('sessionKey', sessionKey);

  //FCM
  await FirebaseMessaging.instance.subscribeToTopic('all');
  String? token = await FirebaseMessaging.instance.getToken();
  if(token != null) {
    await saveTokenToDatabase(token);
  }
  // Any time the token refreshes, store this in the database too.
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
}

Future<void> saveTokenToDatabase(String token) async {

  DocumentSnapshot member = await getDocumentSnapshotUsingSharedPreferences();

  await member.reference.update({
    'FCMTokens' : FieldValue.arrayUnion([token]),
  });
}

Future logOutCleanUp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String sessionKey = prefs.getString('sessionKey')!;
  String username = prefs.getString('username')!;
  DocumentSnapshot userDocSnap = await getDocumentSnapshot('members', username);
  List<String> sessionKeys = getListFromJSONArray(userDocSnap.get('sessionKeys'));
  sessionKeys.remove(sessionKey);
  await userDocSnap.reference.update({
    'sessionKeys' : sessionKeys,
  });
  await prefs.clear();

  //FCM
  await FirebaseMessaging.instance.unsubscribeFromTopic('all');
}


Future<bool> isSavedSessionKeyValid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey('username') && prefs.getString('username')!= null &&
      prefs.containsKey('sessionKey') && prefs.getString('sessionKey') != null) {
    DocumentSnapshot  memberDocSnapshot = await getDocumentSnapshot('members', prefs.getString('username')!);

    List<String> sessionKeys = getListFromJSONArray(memberDocSnapshot.get('sessionKeys'));

    if(sessionKeys.contains(prefs.getString('sessionKey'))){
      return true;
    }
  }
  return false;
}