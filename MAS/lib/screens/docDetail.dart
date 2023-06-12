import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import '../common/alert_info.dart';
import '../constant/colors.dart';
class DoctorDetails extends StatefulWidget {
  //const DoctorDetails({Key? key}) : super(key: key);
  String uid;
  final userId;
  final date;
  final time;
  final doctorName;
  final doctorId;
  final symptoms;
  final userName;
  final cValue;
  DoctorDetails(this.uid,this.userId,this.date,this.time,this.doctorName,this.doctorId,this.symptoms,this.userName,this.cValue);

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  String? name;
  Future<void> compareStringWithKey() async {
    // Access the Firestore collection
    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('appointmentDetails');

    // Query the collection with the condition
    QuerySnapshot querySnapshot = await collectionRef
        .where('doctor', isEqualTo: widget.doctorName)
        .get();

    // Iterate over the documents that match the condition
    querySnapshot.docs.forEach((doc) {
      // Access the document data
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Access specific fields
      String field = data['doctor'];

      // Do something with the field value
      print('Field value: $field');
      print('Field value 2nd' + widget.doctorName.toString());
    });
  }

  Future<bool> getAppointmentDate() async {
    print("GET APPOINTEMENT DATE INMIT");
    try {
      String? date = "";
      String? field = "";

      final db = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;
      await db
          .collection("appointmentDetails")
          .where('userId', isEqualTo: widget.userId)
          .get()
          .then((value) {
        date = value.docs.first.data()['date'];
      });

      // compareStringWithKey();
      CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('appointmentDetails');

      // Query the collection with the condition
      QuerySnapshot querySnapshot = await collectionRef
          .where('doctor', isEqualTo: widget.doctorName)
          .get();

      // Iterate over the documents that match the condition
      querySnapshot.docs.forEach((doc) {
        // Access the document data
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        field = data['doctor'];
      });
      log("getAppointmentDate, $date");
      DateTime appointmentDate = DateTime.parse(date!);

      if ((appointmentDate.compareTo(DateTime.now()) <= 1) &&
          (field.toString() == widget.doctorName.toString())) {
        return true;
      }
    } catch (ex) {
      log(ex.toString());
    }
    return false;
  }

  void saveAppointmentDetails() async {
    final db = FirebaseFirestore.instance;
    if (widget.time.isEmpty) {
      AlertInfo(
          message: "Missed To Select Time.",
          backgroundColor: shrineErrorRed)
          .showInfo(context);
      return;
    }
    if (widget.date!.isEmpty) {
      AlertInfo(
          message: "Missed To Select Date.",
          backgroundColor: shrineErrorRed)
          .showInfo(context);
      return;
    }
    // if (await getAppointmentDate()) {
    //   AlertInfo(
    //       message: "You have already a Booking.",
    //       backgroundColor: shrineErrorRed)
    //       .showInfo(context);
    //   Future.delayed(const Duration(seconds: 2))
    //       .then((value) => Navigator.pop(context));
    //   return;
    // }
    try {
      print("TRYINGGGGG");
      await db
          .collection('appointmentDetails')
          .add({
        "userId": widget.userId,
        "date": widget.date,
        "time": widget.time,
        "doctor": name,
        "doctorId": widget.uid.toString().trim(),
        "symptoms": widget.symptoms,
        "userName": widget.userName,
        "Urgent": widget.cValue.toString(),
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('doctor')
                .doc(widget.uid.toString().trim())
                .get(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print("SNAPSHOT CONNECTION WAITING");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data!.data();
                print("DR UID      "+widget.uid);
                print("DATA"+data.toString());
                name = data!['name'];
                print("NAME   "+name.toString());
                var nmcNo = data!['nmcNo'].toString();
                var specialization = data!['specialization'].toString();
                var qualification = data!['qualification'].toString();
                var mobile = data!['mobile'].toString();
                var visitingHospital = data!['visitingHospital'].toString();
                var vistingTime = data!['vistingTime'].toString();
                return SafeArea(
                    child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registar',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),

                              SizedBox(height: 10),

                              Text(
                                'Name : '+ name.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),

                              SizedBox(height: 10),

                              Text(
                                'NMC No : '+nmcNo,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                              SizedBox(height: 10),

                              Text(
                                'Mobile No : '+mobile,
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),


                              SizedBox(height: 10),

                              Text(
                                'Speciality : ',
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5),
                                child: Text(
                                  specialization,
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              Text(
                                'Academic Qalifications : ',
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5),
                                child: Text(
                                  qualification,
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),

                              Text(
                                'Visiting Time: ',
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5),
                                child: Text(
                                  vistingTime,
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                              ),
                              ElevatedButton(onPressed: () {
                                saveAppointmentDetails();
                              }, child: Text("Book")),
                              Container(
                                height: 150,
                                decoration: const BoxDecoration(
                                    color: Colors.purple
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      visitingHospital,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25
                                      ),
                                    ),

                                    SizedBox(height: 15),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on_sharp,
                                          color: Colors.white,
                                        ),

                                        SizedBox(width: 20),

                                        Text(
                                          'P. Box No: 555-222-333,',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16
                                          ),
                                        ),


                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

                        ),
                      ),

                    )

                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}