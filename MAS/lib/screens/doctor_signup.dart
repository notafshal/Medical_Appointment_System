import 'dart:developer';

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

class DoctorSignup extends StatefulWidget {
  const DoctorSignup({Key? key}) : super(key: key);

  @override
  State<DoctorSignup> createState() => _DoctorSignupState();
}

class _DoctorSignupState extends State<DoctorSignup> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paswordController = TextEditingController();
  final TextEditingController _nmcNo = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _specialization = TextEditingController();
  final TextEditingController _vistingHospital = TextEditingController();
  final TextEditingController _qualification = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isValidate = false;
  bool formIsValid = false;
  String? categories;
  bool? hidePassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: SafeArea(
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
              Text("Sign Up", style: AppTextStyle.headline2),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Create an account to access healthcare, and more.",
                  style: AppTextStyle.subtitle1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have an account?",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: GestureDetector(
                        child: Text(
                          "Login",
                          style: AppTextStyle.inkWellLink,
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonTextField(
                          width: MediaQuery.of(context).size.width * 0.43,
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return "First Name Can't Be Empty";
                            }
                            return null;
                          },
                          labelText: "First Name",
                          controller: _firstnameController,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        CommonTextField(
                          width: MediaQuery.of(context).size.width * 0.43,
                          labelText: "Last Name",
                          controller: _lastnameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Last Name Can't Be Empty";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    CommonTextField(
                      labelText: "Qualification",
                      controller: _qualification,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Qualication Can't Be Empty";
                        }
                        return null;
                      },
                    ),
                    CommonTextField(
                      labelText: "Email Address",
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email Address Can't Be Empty";
                        }
                        return null;
                      },
                    ),
                    CommonTextField(
                      obscureText: hidePassword!,
                      labelText: "Password",
                      controller: _paswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password Can't Be Empty";
                        }
                        return null;
                      },
                      suffix: IconButton(
                        icon: hidePassword!
                            ? const Icon(
                                Icons.visibility,
                                color: white,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: white,
                              ),
                        onPressed: () {
                          setState(() {
                            if (hidePassword!) {
                              hidePassword = false;
                            } else {
                              hidePassword = true;
                            }
                          });
                        },
                      ),
                    ),
                    CommonTextField(
                      labelText: "NMC No",
                      controller: _nmcNo,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "MNC No Can't Be Empty";
                        }
                        return null;
                      },
                    ),
                    CommonTextField(
                      labelText: "Mobile Number",
                      controller: _mobile,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Mobile Number Can't Be Empty";
                        } else if (value.length != 10) {
                          return "Phone Length Must Be 10";
                        }
                        return null;
                      },
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
                    DropDownField(
                      isCategories: true,
                      chosenValue: categories,
                      onChanged: (String? value) {
                        setState(() {
                          categories = value;
                        });
                        return categories;
                      },
                    ),
                    CommonTextField(
                      labelText: "Visting Hospital/Clinic",
                      controller: _vistingHospital,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field Can't Be Empty";
                        }
                        return null;
                      },
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
                  text: "Create an account",
                  onPressed: () {
                    DoctorSignup();
                  },
                  size: MediaQuery.of(context).size.width * 0.9),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Customize your visting date and time after signup.",
                  style: AppTextStyle.subtitle2,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> DoctorSignup() async {
    if (!_formKey.currentState!.validate()) {
      log("Form Validation Error");
      return;
    }
    try {
      final UserCredential userCredential;
      final db = FirebaseFirestore.instance;
      // Doctor Registration
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _paswordController.text);
      String? uid = userCredential.user?.uid;
      // Sending Email Verification
      log("Sening Email Verification ${userCredential.user}");
      await userCredential.user!.sendEmailVerification();

      // Set Doctor Display Name
      userCredential.user!.updateDisplayName(
          "${_firstnameController.text.trim()} ${_lastnameController.text.trim()}");

      // Store Doctor Additional Info to doctor
      db
          .collection('doctor')
          .doc(userCredential.user!.uid)
          .set({
            "name":
                "${_firstnameController.text.trim()} ${_lastnameController.text.trim()}",
            "email": _emailController.text.trim(),
            "qualification": _qualification.text.trim(),
            "nmcNo": _nmcNo.text.trim(),
            "mobile": _mobile.text.trim(),
            "specialization": categories!.trim(),
            "visitingHospital": _vistingHospital.text.trim(),
            "isDoctor": true,
            "vistingTime": "10:00-16:00",
            "createdAt": DateTime.parse(Timestamp.now().toDate().toString()),
            "uid" : uid,
            "symptoms" : " ",
          })
          .then((value) => AlertInfo(
                  message: "Registration Success"
                      ". Email Verifaction Sent",
                  isSuccess: true,
                  backgroundColor: successAlert)
              .showInfo(context))
          // Push Back To Login Page After Successful Registration
          .then((value) => Navigator.pushReplacementNamed(context, '/'));
    } catch (ex) {
      log(ex.toString());
      AlertInfo(
              message: "Registration Failed.",
              isSuccess: false,
              backgroundColor: shrineErrorRed)
          .showInfo(context);
    }
  }

  String? validateButton(String? value) {
    log(value.toString());
    if (value!.isEmpty) {
      return 'Please Enter Some Text';
    }
    return null;
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _paswordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
