import 'package:doctor/constant/colors.dart';
import 'package:flutter/material.dart';

class AlertInfo {
  final String? message;
  Color? backgroundColor;
  bool isSuccess;
  AlertInfo({this.message, this.isSuccess = false, this.backgroundColor});

  ScaffoldFeatureController showInfo(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          isSuccess
              ? const Icon(
                  Icons.thumb_up_sharp,
                  color: white,
                )
              : const Icon(
                  Icons.thumb_down_sharp,
                  color: white,
                ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            message!,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    ));
  }
}
