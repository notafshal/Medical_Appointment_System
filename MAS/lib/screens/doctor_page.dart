import 'package:doctor/common/appointment_list.dart';
import 'package:doctor/common/user_info_card.dart';
import 'package:doctor/screens/invstigation_report.dart';
import 'package:doctor/screens/login_page.dart';
import 'package:flutter/material.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  bool? isDoctor;
  String? doctorName;
  String? specialization;
  String? nmcNo;
  bool _canPop = false;

  @override
  void didChangeDependencies() {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    isDoctor = arguments['isDoctor'];
    specialization = arguments['specialization'];
    nmcNo = arguments['nmcNo'];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Alert"),
              content: Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/');
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: Text("Yes"),
                ),
              ],
            ),
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Home"),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserInfoCard(
                    height: MediaQuery.of(context).size.height / 6,
                    profileIcon: false,
                    specialization: specialization,
                    nmcNo: nmcNo,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: const Text(
                      "Your Appointment List",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Center(
                    child: AppointmentInfoCard(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
