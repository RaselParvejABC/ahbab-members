import 'package:flutter/foundation.dart';

class ExpectedTakeOutMonth extends ChangeNotifier {
  DateTime? _dateTime;

  DateTime? get getTime {
    return _dateTime;
  }

  set setTime (DateTime? newDateTime){
    _dateTime = newDateTime;
    notifyListeners();
  }
}