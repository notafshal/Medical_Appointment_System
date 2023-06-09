import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/common/alert_info.dart';
import 'package:doctor/constant/colors.dart';
import 'package:doctor/screens/invstigation_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../common/text_style.dart';
import 'package:flutter/material.dart';

import '../common/card_design.dart';
import '../common/custom_clipper.dart';
import '../common/tabbar_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String? profileImageLocation;
  String? userName = "";
  String? joinedDate = "";
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  @override
  void initState() {
    scrollController;
    getProfileImage();
    getUserInfo();
    TabController tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Future getProfileImage() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        setState(() {
          profileImageLocation = value["profileImage"].toString();
        });
        log(profileImageLocation!);
      });
    } catch (e) {
      profileImageLocation =
          "https://firebasestorage.googleapis.com/v0/b/doctorg-abf97.appspot.com/o/files%2Fistockphoto-1406197730-1024x1024.jpg?alt=media&token=f37bd4d9-01f0-44cf-b405-7d26dc4bacc2";
    }
  }

  Future getUserInfo() async {
    await db.collection("users").doc(user!.uid).get().then((value) {
      // Convert TimeStamp to DateTime
      DateTime dt = (value['createdAt'] as Timestamp).toDate();
      setState(() {
        userName = value["name"].toString();
        joinedDate = DateFormat('MM/dd/yyyy').format(dt);
      });
    });
  }

  @override
  void dispose() {
    scrollController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    ClipPath(
                      clipper: ProfileClipper(),
                      child: Container(
                        height: 150,
                        color: card,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ],
                ),
                Circleavatar(
                  top: 60,
                  left: 160,
                  radius: 40,
                  iconChild: GestureDetector(
                    child: ClipOval(
                      child: profileImageLocation == null
                          ? const Icon(Icons.person)
                          : Image.network(
                              profileImageLocation!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    onTap: () {
                      imgFromGallery(context);
                    },
                  ),
                ),
                Circleavatar(
                  top: 50,
                  left: 40,
                  radius: 20,
                  iconChild: IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Circleavatar(
                  top: 50,
                  right: 40,
                  radius: 20,
                  iconChild: IconButton(
                    icon: const Icon(Icons.logout_outlined),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userName!,
              style: AppTextStyle.headline2,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              joinedDate!,
              style: AppTextStyle.subtitle1,
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Your Recent history",
                      style: AppTextStyle.headline3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width,
                    child: InvestigationReport(),
                  ),
                ),
                const Positioned(
                    bottom: 0,
                    child: AutoSizeText(
                      "Eat Healthy , Stay Healthy",
                      style: TextStyle(color: white, fontSize: 15),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future imgFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 512, maxWidth: 512);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile(context);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(BuildContext context) async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    const destination = 'files/';
    try {
      final ref = FirebaseStorage.instance.ref(destination).child(fileName);
      final dbRef = FirebaseFirestore.instance.collection('users');
      await ref.putFile(_photo!).then((p0) {
        ref.getDownloadURL().then(
            (value) => dbRef.doc(user!.uid).update({"profileImage": value}));
        AlertInfo(
                message: "Profile Pic Uploaded Successfully",
                isSuccess: true,
                backgroundColor: successAlert)
            .showInfo(context);
      });
    } catch (e) {
      log("Error In Uploading Profile Pic");
      AlertInfo(
              message: "Error WHile Uploading", backgroundColor: shrineErrorRed)
          .showInfo(context);
    }
  }
}

class Circleavatar extends StatelessWidget {
  double? top;
  double? left;
  double? right;
  double? radius;
  Widget? iconChild;

  Circleavatar({
    Key? key,
    required this.iconChild,
    this.left,
    this.right,
    required this.radius,
    required this.top,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: white, width: 2),
          color: Colors.white,
        ),
        child: CircleAvatar(
          radius: radius,
          child: iconChild,
        ),
      ),
    );
  }
}
