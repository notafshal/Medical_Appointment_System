import 'package:doctor/common/appointment_list.dart';
import 'package:doctor/common/user_info_card.dart';
import 'package:doctor/screens/invstigation_report.dart';
import 'package:doctor/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:doctor/common/urgentInfoCard.dart';
class AppListU extends StatefulWidget {
  const AppListU({Key? key}) : super(key: key);

  @override
  State<AppListU> createState() => _AppListUState();
}

class _AppListUState extends State<AppListU> {
  bool? isDoctor;
  String? doctorName;
  String? specialization;
  String? nmcNo;
  bool _canPop = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // UserInfoCard(
              //   height: MediaQuery.of(context).size.height / 6,
              //   profileIcon: false,
              //   specialization: specialization,
              //   nmcNo: nmcNo,
              // ),
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "Your Appointment List",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

              ),
              Container(
                margin: const EdgeInsets.all(10),
                child:
                const Text(
                  "Urgent Appointments",
                  style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(
                child: AppointmentInfoCardUrgent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
