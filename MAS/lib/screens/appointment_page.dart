import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/common/alert_info.dart';
import 'package:doctor/constant/colors.dart';
import 'package:doctor/widget/appointment_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../common/time_range.dart';
import '../common/user_info_card.dart';
import '../provider/TimeProvider.dart';

class AppointmentPage extends StatefulWidget {
  String? doctorName;
  String? specialization;
  String? doctorId;
  String? nmcNo;
  String? selectedTime;
  AppointmentPage(
      {Key? key,
      this.doctorName,
      this.specialization,
      this.doctorId,
      this.nmcNo,
      this.selectedTime})
      : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController _symptomsController = TextEditingController();
  String? date;
  String? selectedTime;
  @override
  void initState() {
    _selectedDay = _focusedDay;
    dateTimeController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              UserInfoCard(
                height: MediaQuery.of(context).size.height / 6,
                name: widget.doctorName,
                profileIcon: false,
                specialization: widget.specialization,
                nmcNo: widget.nmcNo,
              ),
              const SizedBox(
                height: 40,
                child: Text("Select Your Date"),
              ),
              TableCalendar(
                rowHeight: 30,
                focusedDay: DateTime.now(),
                firstDay: DateTime(2010),
                lastDay: DateTime(2070),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    // Call `setState()` when updating the selected day
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    Provider.of<TimeProvider?>(context, listen: false)!
                        .selectedDate(
                            DateFormat("yyyy-MM-dd").format(_selectedDay!));
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
                weekendDays: const [
                  DateTime.saturday
                ], // Disable According To Doctor's Availiability
              ),
              Text("${DateFormat("yyyy-MM-dd").format(_selectedDay!)}"),
              Container(
                margin: const EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: AppointmentTime(
                  doctorId: widget.doctorId,
                  dateSelected: context.read<TimeProvider>().dateSelected,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _symptomsController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.info), //icon of text field
                      labelText: "Mention any symptoms" //label text of field
                      ),
                ),
              ),
              Text("${context.read<TimeProvider>().timeSelected}"),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      saveAppointmentDetails();
                    },
                    child: const Text("Book Appointment")),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        dateTimeController.text = newTime.format(context);
      });
    }
  }

  Future<bool> getAppointmentDate() async {
    try {
      String? date = "";
      final db = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;
      await db
          .collection("appointmentDetails")
          .where('userId', isEqualTo: user!.uid)
          .get()
          .then((value) {
        date = value.docs.first.data()['date'];
      });
      log("getAppointmentDate, $date");
      DateTime appointmentDate = DateTime.parse(date!);
      if (appointmentDate.compareTo(DateTime.now()) <= 1) {
        return true;
      }
    } catch (ex) {
      log(ex.toString());
    }
    return false;
  }

  void saveAppointmentDetails() async {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    date = DateFormat("yyyy-MM-dd").format(_selectedDay!);
    final todayDate = DateFormat("yyy-MM-dd").format(DateTime.now());
    final time = context.read<TimeProvider?>()!.timeSelected;

    if (time.isEmpty) {
      AlertInfo(
              message: "Missed To Select Time.",
              backgroundColor: shrineErrorRed)
          .showInfo(context);
      return;
    }
    if (date!.isEmpty) {
      AlertInfo(
              message: "Missed To Select Date.",
              backgroundColor: shrineErrorRed)
          .showInfo(context);
      return;
    }
    if (await getAppointmentDate()) {
      AlertInfo(
              message: "You have already a Booking.",
              backgroundColor: shrineErrorRed)
          .showInfo(context);
      Future.delayed(const Duration(seconds: 2))
          .then((value) => Navigator.pop(context));
      return;
    }
    if (!_selectedDay!.isBefore(DateTime.now())) {
      try {
        await db
            .collection('appointmentDetails')
            .add({
              "userId": user!.uid,
              "date": date,
              "time": context.read<TimeProvider>().timeSelected,
              "doctor": widget.doctorName,
              "doctorId": widget.doctorId,
              "symptoms": _symptomsController.text.trim(),
              "userName": user.displayName
            })
            .then((value) => AlertInfo(
                    message: "Appointment Booked",
                    isSuccess: true,
                    backgroundColor: successAlert)
                .showInfo(context))
            .then((value) => Navigator.pop(context));
      } on FirebaseException catch (ex) {
        log(ex.toString());
        AlertInfo(
                message: "Some Error Occured", backgroundColor: shrineErrorRed)
            .showInfo(context);
      } catch (ex) {
        AlertInfo(
                message: "Some Error Occured", backgroundColor: shrineErrorRed)
            .showInfo(context);
      }
    } else {
      AlertInfo(
              message: "Date Can't Be In Past", backgroundColor: shrineErrorRed)
          .showInfo(context);
    }
  }
}
