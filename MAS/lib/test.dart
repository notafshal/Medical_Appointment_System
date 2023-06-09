import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main(List<String> args) {
  final date = Timestamp.now();
  final dateCon = DateTime.parse(date.toDate().toString());
  final d = Map.from(doctor);
  print(d["doctor"]);

  print("Date is $dateCon");
}

final Map doctor = {
  "doctor": [
    {"name": "Afshal Maharjan", "specialities": "Cardiologist"},
    {"name": "Mamit Pradhan", "specialities": "Cardiologist"},
    {"name": "Bishal Gurung", "specialities": "Cardiologist"},
    {"name": "Manish Aryal", "specialities": "Cardiologist"}
  ]
};
