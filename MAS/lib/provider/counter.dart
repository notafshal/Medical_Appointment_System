import 'package:flutter/cupertino.dart';

class CountNumber extends ChangeNotifier {
  int count = 0;

  int getCount() {
    return count;
  }

  updateCount() {
    count++;
    notifyListeners();
  }
}
