import 'dart:developer';

import 'package:flutter/cupertino.dart';

class TimeProvider extends ChangeNotifier {
  String timeSelected = "";
  String dateSelected = "";

  String? selectTime(time) {
    log(time);
    timeSelected = time;
    notifyListeners();
    return timeSelected;
  }

  String? selectedDate(date) {
    dateSelected = date;
    notifyListeners();
    return dateSelected;
  }
}
