import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  String? labelText;
  TextEditingController? controller;
  Widget? suffix;
  TextInputType? textInputType;
  String? errorText;
  bool? isDropdown;
  double? width;
  bool obscureText;
  CommonTextField(
      {Key? key,
      required this.labelText,
      required this.controller,
      this.errorText,
      this.textInputType,
      this.validator,
      this.suffix,
      this.width,
      this.obscureText = false})
      : super(key: key);

  String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.white),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.060,
              width: width != null
                  ? width
                  : MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFFFFFFF).withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                obscureText: obscureText,
                validator: validator,
                keyboardType: textInputType,
                controller: controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    errorText: errorText,
                    contentPadding:
                        const EdgeInsets.only(left: 14.0, top: 10.0),
                    border: InputBorder.none,
                    labelText: labelText,
                    suffix: suffix,
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                    focusColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.auto),
              )),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
