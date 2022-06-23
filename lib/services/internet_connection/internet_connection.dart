import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> isConnectedToInternet() async {
  return await InternetConnectionChecker().hasConnection;
}