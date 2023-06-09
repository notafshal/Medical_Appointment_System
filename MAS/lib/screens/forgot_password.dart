import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common/text_style.dart';
import '../widget/button.dart';
import '../widget/logo_container.dart';
import '../widget/textField.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController =
      TextEditingController(text: "");
  String? buttonLabel;
  @override
  void initState() {
    buttonLabel = "Reset Password";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: LogoName(
              height: 20,
              width: 20,
              textSize: 18,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text("Forgot Password ?", style: AppTextStyle.headline3),
          const SizedBox(
            height: 15,
          ),
          CommonTextField(
            labelText: "Email Address",
            controller: _emailController,
            textInputType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter Email Address";
              }
              return null;
            },
          ),
          MaterialCommonButton(
            isImage: false,
            onPressed: () => getUserByEmailAndSendPasswordResetLink(
                _emailController.text.trim()),
            size: MediaQuery.of(context).size.width * 0.9,
            color: Theme.of(context).primaryColor,
            text: buttonLabel,
          ),
        ],
      )),
    );
  }

// Get User From List  
  getUserByEmailAndSendPasswordResetLink(String email) async {
    bool isExists = false;
    // Fetch Email Existence From Authentication Lists
    await _auth.fetchSignInMethodsForEmail(email).then((value) {
      value.isNotEmpty ? isExists = true : isExists = false;
    });
    log("Email Exists $isExists");
    if (!isExists) {
      setState(() {
        buttonLabel = "Sorry User Don't Exists";
      });
      return;
    }
    setState(() {
      buttonLabel = "Check Your Email";
    });

    _auth.sendPasswordResetEmail(email: email);
  }
}
