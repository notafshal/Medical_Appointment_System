// To parse this JSON data, do
//
//     final doctors = doctorsFromJson(jsonString);

import 'dart:convert';

Doctors doctorsFromJson(String str) => Doctors.fromJson(json.decode(str));

String doctorsToJson(Doctors data) => json.encode(data.toJson());

class Doctors {
  Doctors({
    required this.doctor,
  });

  List<Doctor> doctor;

  factory Doctors.fromJson(Map<String, dynamic> json) => Doctors(
        doctor:
            List<Doctor>.from(json["doctor"].map((x) => Doctor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "doctor": List<dynamic>.from(doctor.map((x) => x.toJson())),
      };
}

class Doctor {
  Doctor({
    required this.name,
    required this.specialities,
  });

  String name;
  String specialities;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        name: json["name"],
        specialities: json["specialities"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "specialities": specialities,
      };
}
