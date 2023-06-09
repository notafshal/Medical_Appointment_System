import 'package:flutter/material.dart';

class LogoName extends StatelessWidget {
  double height;
  double width;
  double textSize;
  LogoName({
    Key? key,
    required this.height,
    required this.width,
    required this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: height,
          width: height,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Medical Appointment System",
            softWrap: true,
            style: TextStyle(
                fontSize: textSize,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "®",
          style: TextStyle(color: Colors.white, fontSize: 10),
        )
      ],
    );
  }
}
