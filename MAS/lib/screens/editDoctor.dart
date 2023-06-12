import 'dart:developer';
import 'package:doctor/screens/doctor_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/common/alert_info.dart';
import 'package:doctor/constant/colors.dart';
import 'package:doctor/common/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/button.dart';
import '../widget/drop_down.dart';
import '../widget/logo_container.dart';
import '../widget/textField.dart';
import 'login_page.dart';

class editDoctor extends StatefulWidget {
  const editDoctor({Key? key}) : super(key: key);

  @override
  State<editDoctor> createState() => _editDoctorState();
}

class _editDoctorState extends State<editDoctor> {
  TextEditingController _nmcNo = TextEditingController();
  final TextEditingController _specialization = TextEditingController();
  final TextEditingController _vistingHospital = TextEditingController();
  final TextEditingController _qualification = TextEditingController();
  final TextEditingController _vistingTime = TextEditingController();
  final TextEditingController _symptomsC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isValidate = false;
  bool formIsValid = false;
  String? categories;
  bool? hidePassword;
  var name="";
  var specialization="";
  var nmcNo="";
  var qualification ="";
  var mobile="";
  var visitingHospital="";
  var vistingTime="";
  var symptoms="";
  Future<Map<String, dynamic>?> extractDataFromDocument() async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('doctor')
          .doc(auth.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        name = data!['name'];
        nmcNo = data!['nmcNo'].toString();
        specialization = data!['specialization'].toString();
        qualification = data!['qualification'].toString();
        mobile = data!['mobile'].toString();
        visitingHospital = data!['visitingHospital'].toString();
        vistingTime = data!['vistingTime'].toString();
        symptoms = data!['symptom'];
        _nmcNo.text = nmcNo;
        _specialization.text = specialization;
        _qualification.text = qualification;
        _vistingTime.text = vistingTime;
        _symptomsC.text = symptoms;
       print("DATA                "+name);
      } else {
        // Document does not exist
        return null;
      }
    } catch (e) {
      print('Error extracting data from document: $e');
      return null;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      extractDataFromDocument();
    });

    super.initState();
    hidePassword = true;
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: primary,
        body: SingleChildScrollView(
          child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: LogoName(
                          height: 20,
                          width: 20,
                          textSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text("Information Page", style: AppTextStyle.headline2),
                      Padding(
                        padding: const EdgeInsets.all(8.0),

                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(name, style: AppTextStyle.headline3),
                                const SizedBox(
                                  width: 20,
                                ),

                              ],
                            ),
                            CommonTextField(
                              hintText: qualification,
                              labelText: "Qualification",
                              controller: _qualification,
                            ),

                            CommonTextField(
                              hintText: nmcNo,
                              labelText: "nmcNo",
                              controller: _nmcNo,
                            ),

                            // CommonTextField(
                            //   labelText: "Specilization",
                            //   controller: _specialization,
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return "Specialization Can't Be Empty";
                            //     }
                            //     return null;
                            //   },
                            // ),
                            CommonTextField(
                              hintText: specialization,
                              labelText: "Specialization",
                              controller: _specialization,
                            ),
                            CommonTextField(
                              hintText: vistingTime,
                              labelText: "Visiting Time",
                              controller: _vistingTime,

                            ),
                            CommonTextField(
                              hintText: symptoms,
                              labelText: "Symptoms",
                              controller: _symptomsC,

                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MaterialCommonButton(
                          isImage: false,
                          color: Colors.blue,
                          text: "Submit",
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection('doctor')
                                .doc(auth.currentUser!.uid)
                                .update({
                         //   'name' : name,
                            'nmcNo' : _nmcNo.text,
                            'specialization' : _specialization.text,
                            'qualification' : _qualification.text,
                            'vistingTime' : _vistingTime.text,
                            'symptom' : _symptomsC.text,

                            }).then((value) {
                              Navigator.pop(context);
                            }).onError((error, stackTrace) async {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Error'),
                                        content: Text(error.toString()),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ));
                            });
                          },
                          size: MediaQuery.of(context).size.width * 0.9),
                      const SizedBox(
                        height: 15,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                  ]),
        ),
      ),
    );
  }
}
