import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/common/pdf_download.dart';
import 'package:doctor/common/pdf_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppointmentInfoCardUrgent extends StatefulWidget {
  const AppointmentInfoCardUrgent({Key? key});

  @override
  State<AppointmentInfoCardUrgent> createState() => _AppointmentInfoCardUrgentState();
}

class _AppointmentInfoCardUrgentState extends State<AppointmentInfoCardUrgent> {
  Future<DocumentSnapshot?> getDocumentByUID(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('appointmentDetails').doc(uid).get();

      if (snapshot.exists) {
        // Document exists, return the snapshot
        return snapshot;
      } else {
        // Document does not exist
        return null;
      }
    } catch (e) {
      // Error occurred while fetching the document
      print('Error: $e');
      return null;
    }
  }

  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.uid;
  String pdfPath = "";

  @override
  void initState() {
    super.initState();
    fromAsset("assets/sample.pdf", 'sample.pdf').then((f) {
      log("File $f");
      setState(() {
        pdfPath = f.path;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointmentDetails')
            .where('doctorId', isEqualTo: user)

        // Sort by 'urgent' field in descending order (true first)

            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshots.hasError || snapshots.data == null) {
            return Text('Error: ${snapshots.error}');
          }

          final appointmentDocs = snapshots.data!.docs;

          if (appointmentDocs.isEmpty) {
            return Text('No Appointments');
          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: appointmentDocs.length,
            itemBuilder: (context, index) {
              var data = appointmentDocs[index].id;
              return FutureBuilder<DocumentSnapshot?>(
                future: getDocumentByUID(data),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // Document exists, access the data
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    if(data['Urgent']==1)
                      {
                        String name = data['userName'];
                        String symptoms = data['symptoms'];
                        String date = data['date'];
                        String time = data['time'];

                        return GestureDetector(
                          onTap: () {
                            if (pdfPath.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfReport(pdfPath: pdfPath),
                                ),
                              );
                            }
                          },
                          child: Card(
                            child: ListTile(
                              leading: Text(name),
                              trailing: Text(symptoms),
                              title: Text(date),
                              subtitle: Text(time),
                            ),
                          ),
                        );
                      }
                  }
                  return Text('');
                },
              );
            },
          );
        },
      ),
    );
  }
}
