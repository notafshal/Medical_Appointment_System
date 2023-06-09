import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/constant/colors.dart';
import 'package:doctor/provider/TimeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../common/time_range.dart';

class AppointmentTime extends StatefulWidget {
  final String? doctorId;
  final String? dateSelected;
  const AppointmentTime({super.key, this.doctorId, this.dateSelected});

  @override
  State<AppointmentTime> createState() => _AppointmentTimeState();
}

class _AppointmentTimeState extends State<AppointmentTime> {
  List<dynamic> appointmentTime = [];
  List appointmentTimeCopy = [];
  List availableTime = [];

  final db = FirebaseFirestore.instance;

  Color? chipColor;
  String? timeSelected;
  int? _selectedIndex;
  bool? isDisabled;
  TimeProvider? onDateSelected;

  @override
  void initState() {
    super.initState();
    isDisabled = false;
    chipColor = Colors.blue;
    timeSelected = "0.0";
  }

  @override
  void didUpdateWidget(covariant AppointmentTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    getAppointmentRange();
  }

  getAppointmentRange() async {
    log("Getting Appointment Range");
    onDateSelected = Provider.of<TimeProvider>(context, listen: false);
    log("Doc ID,${widget.doctorId}");
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      await db.collection("doctor").doc(widget.doctorId).get().then((value) {
        setState(() {
          if (value.data() != null) {
            appointmentTime = generateTimeRange(value.data()!['vistingTime']);
          } else {
            appointmentTime = generateTimeRange("10:00-16:00");
          }
        });
        // log(value.data()!['vistingTime']);
      }).then((value) => checkForBookedTime(onDateSelected!.dateSelected));
    } catch (ex) {
      log(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100, childAspectRatio: 3 / 2),
      shrinkWrap: true,
      itemCount: appointmentTime.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return GestureDetector(
          onTap: () => setState(() {
            timeSelected = appointmentTime[index];
            _selectedIndex = index;
            Provider.of<TimeProvider?>(context, listen: false)!
                .selectTime(timeSelected);
          }),
          child: Chip(
            backgroundColor: index == _selectedIndex
                ? Colors.blue.withOpacity(0.6)
                : Colors.blue,
            label: Text(
              appointmentTime[index],
              style: const TextStyle(color: white),
            ),
          ),
        );
      },
    );
  }

  checkForBookedTime(String dateSelected) async {
    try {
      List data = await db.collection("appointmentDetails").get().then(
          (value) => value.docs
              .where((item) => widget.doctorId == item['doctorId'])
              .toList());
      appointmentTimeCopy = List.from(appointmentTime);
      for (var item in data) {
        // log(item['date']);
        if (dateSelected == item['date']) {
          appointmentTimeCopy.remove(item['time']);
          setState(() {
            appointmentTime = appointmentTimeCopy;
          });
        }
      }
    } on FirebaseFirestore catch (e) {
      log(e.toString());
    }
  }
}
