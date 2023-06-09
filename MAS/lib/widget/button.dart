import 'package:flutter/material.dart';

class MaterialCommonButton extends StatelessWidget {
  String? text;
  Color? color;
  double size;
  Function()? onPressed;
  bool? isImage = false;
  Image? image;
  MaterialCommonButton(
      {Key? key,
      required this.color,
      this.text = "button",
      required this.onPressed,
      required this.size,
      required this.isImage,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: size,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: isImage == false
              ? Text(
                  text!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )
              : image,
        ));
  }
}
