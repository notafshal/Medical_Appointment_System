import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/common/doctorCard.dart';
import 'package:doctor/constant/const.dart';
import 'package:doctor/screens/invstigation_report.dart';
import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
  CategoriesCard({super.key});

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.docs
                  .map((doc) => GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorCard(
                                      doctorByCategory: true,
                                      specialization: doc['label'],
                                    ))),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Image.network(
                                    categoriesLogo!,   
                                    fit: BoxFit.contain,
                                    color: Colors.white.withOpacity(0.4),
                                    colorBlendMode: BlendMode.modulate,
                                  ),
                                  AutoSizeText(
                                    doc['label'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ),
                                ]),
                          ),
                        ),
                      ))
                  .toList(),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
