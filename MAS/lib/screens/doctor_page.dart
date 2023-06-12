import 'package:doctor/common/appointment_list.dart';
import 'package:doctor/common/user_info_card.dart';
import 'package:doctor/screens/editDoctor.dart';
import 'package:doctor/screens/invstigation_report.dart';
import 'package:doctor/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:doctor/common/urgentInfoCard.dart';
import 'applist.dart';
import 'applistu.dart';
import 'selectDoctor.dart';
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
            actions: [
              IconButton(onPressed: (

                  ){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => editDoctor()),
                );
              }, icon: Icon(Icons.edit))
            ],
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
                  Container(
                    margin: const EdgeInsets.all(10),

                  ),
                  const Center(
                    child: AppointmentInfoCard(),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.all(10),
                  //   child: const Text(
                  //     "Your Appointment List",
                  //     style:
                  //         TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  //   ),
                  //
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.all(10),
                  //   child: ElevatedButton(
                  //     child: Text('Urgent'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => const AppListU()),
                  //       );
                  //     },
                  //   ),
                  //   // const Text(
                  //   //   "Urgent Appointments",
                  //   //   style:
                  //   //   TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  //   // ),
                  // ),
                  // // const Center(
                  // //   child: AppointmentInfoCardUrgent(),
                  // // ),
                  // Container(
                  //   margin: const EdgeInsets.all(10),
                  //   child: ElevatedButton(
                  //     child: Text('Non Urgent'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => const AppList()),
                  //       );
                  //     },
                  //   ),
                  //   // const Text(
                  //   //   "Urgent Appointments",
                  //   //   style:
                  //   //   TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  //   // ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
