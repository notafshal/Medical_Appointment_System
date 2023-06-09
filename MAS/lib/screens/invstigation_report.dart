import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/common/pdf_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/pdf_download.dart';

class InvestigationReport extends StatefulWidget {
  const InvestigationReport({super.key});

  @override
  State<InvestigationReport> createState() => _InvestigationReportState();
}

class _InvestigationReportState extends State<InvestigationReport> {
  String pdfPath = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromAsset("assets/sample.pdf", 'sample.pdf').then((f) {
      log("File $f");
      setState(() {
        pdfPath = f.path;
      });
    });
  }

  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.uid;
  Text? subtitle = const Text("");
  bool enabledForReport = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: StreamBuilder<QuerySnapshot?>(
          stream: db
              .collection('appointmentDetails')
              .where('userId', isEqualTo: user)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                child: Center(child: Text("No Reports Found")),
              );
            } else if (snapshot.hasData) {
              return ListView(
                  children: snapshot.data!.docs.map(
                (doc) {
                  Future.delayed(Duration.zero, () async {
                    getReportDetails(doc['date']);
                  });

                  return Card(
                    child: ListTile(
                      enabled: enabledForReport,
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
                      trailing: subtitle,
                      title: Text(doc['doctor']),
                      subtitle: Text(doc['date'] + " " + doc['time']),
                    ),
                  );
                },
              ).toList());
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  getReportDetails(String date) {
    DateTime appointmentDate = DateTime.parse(date);
    if (appointmentDate.compareTo(DateTime.now()) >= 1) {
      setState(() {
        subtitle = const Text(
          "Upcoming",
          style: TextStyle(color: Colors.green),
        );
        enabledForReport = false;
      });
    }
  }
}
