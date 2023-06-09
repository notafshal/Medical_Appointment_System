import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/constant/colors.dart';
import 'package:flutter/material.dart';

class DropDownField extends StatefulWidget {
  String? chosenValue;
  bool isCategories;
  String? Function(String?)? onChanged;
  DropDownField(
      {Key? key, this.chosenValue, this.onChanged, required this.isCategories})
      : super(key: key);

  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  final db = FirebaseFirestore.instance;
  List<String>? dropDownValue;
  @override
  void initState() {
    // TODO: implement initState
    log("GetCategories $getCategories()");
    dropDownValue = ["Male", "Female", "Other"];
    widget.isCategories ? getCategories() : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.white),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.060,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFFFFFFF).withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
                value: widget.chosenValue,
                dropdownColor: Colors.blue,
                isExpanded: true,
                iconEnabledColor: white,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                items: dropDownValue!
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value,
                      ),
                    ),
                  );
                }).toList(),
                hint: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.isCategories ? "Specilization" : "Gender",
                    style: TextStyle(color: white, fontSize: 12),
                  ),
                ),
                onChanged: widget.onChanged),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Future<void> getCategories() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('categories');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    widget.isCategories ? dropDownValue!.clear() : dropDownValue;
    // Get data from docs and convert map to List
    // Extract the data from each document
    // List<Map<String, dynamic>> usersList = [];
    List<String> categoriesList = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // usersList.add(data);
      categoriesList.add(data['label']);
    }
    setState(() {
      dropDownValue = categoriesList;
    });
    log("Categories $dropDownValue");
  }
}
