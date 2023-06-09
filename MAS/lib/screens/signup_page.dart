import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/constant/colors.dart';
import 'package:doctor/constant/const.dart';
import 'package:doctor/screens/doctor_signup.dart';
import 'package:doctor/common/text_style.dart';
import 'package:doctor/widget/drop_down.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common/alert_info.dart';
import '../widget/button.dart';
import '../widget/logo_container.dart';
import '../widget/textField.dart';
import 'login_page.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paswordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? Function(String?)? onChanged;
  String? gender;
  final TextEditingController _confirmPaswordController =
      TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isValidate = false;
  bool formIsValid = false;
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
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CommonTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "First Name Can't Be Empty";
                        }
                        return null;
                      },
                      labelText: "First Name",
                      controller: _firstnameController,
                    ),
                    CommonTextField(
                      labelText: "Last Name",
                      controller: _lastnameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Last Name Can't Be Empty";
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
                      labelText: "Age",
                      controller: _ageController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Age Can't Be Empty";
                        }
                        return null;
                      },
                    ),
                    DropDownField(
                      isCategories: false,
                      chosenValue: gender,
                      onChanged: (String? value) {
                        setState(() {
                          gender = value;
                        });
                        return gender;
                      },
                    ),
                    CommonTextField(
                      labelText: "Phone Number",
                      controller: _phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone Can't Be Empty";
                        } else if (value.length != 10) {
                          return "Phone Length Must Be 10";
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
                      obscureText: hidePassword!,
                      labelText: "Confirm Password",
                      controller: _confirmPaswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Confirm Your Password";
                        } else if (_paswordController.text !=
                            _confirmPaswordController.text) {
                          return "Password Missmatch";
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
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialCommonButton(
                  isImage: false,
                  color: Theme.of(context).primaryColorLight,
                  text: "Create an account",
                  onPressed: () {
                    signUp();
                  },
                  size: MediaQuery.of(context).size.width * 0.9),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "For Health Professional",
                  style: AppTextStyle.subtitle1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SignUp Here ! ",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: GestureDetector(
                        child: Text(
                          "SignUp",
                          style: AppTextStyle.inkWellLink,
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DoctorSignup()));
                        },
                      ),
                    ),
                  ],
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

  Future<void> signUp() async {
    log("The gender is $gender");
    if (!_formKey.currentState!.validate()) {
      log("Form Validation Error");
      return;
    }
    try {
      final UserCredential userCredential;
      final db = FirebaseFirestore.instance.collection("users");

      // User Registration
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _paswordController.text);

      // Sending Email Verification
      log("Sening Email Verification ${userCredential.user}");
      await userCredential.user!.sendEmailVerification();

      // Set User Display Name
      userCredential.user!.updateDisplayName(
          "${_firstnameController.text.trim()} ${_lastnameController.text.trim()}");

      // Save Additional User Info to users collection
      db
          .doc(userCredential.user!.uid)
          .set({
            "name":
                "${_firstnameController.text.trim()} ${_lastnameController.text.trim()}",
            "email": _emailController.text.trim(),
            "age": _ageController.text.trim(),
            "gender": gender!.trim(),
            "phone": _phoneController.text.trim(),
            "isAdmin": false,
            "createdAt": DateTime.parse(Timestamp.now().toDate().toString()),
            "profileImage": profileImageDefault
          })
          .then((value) =>
              // Show Success Message
              AlertInfo(
                      message: "Registration Success.",
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
