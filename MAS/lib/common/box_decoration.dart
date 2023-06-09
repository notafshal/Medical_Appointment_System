import 'package:flutter/material.dart';

import 'text_style.dart';

class CommonBoxDecoration extends StatelessWidget {
  double? height;
  double? width;
  Widget? child;
  double? stackHeight;
  double? stackWidth;
  Widget? stackChild;
  String? headingText;
  String? playText;
  String? timeText;
  CommonBoxDecoration(
      {Key? key,
      required this.height,
      required this.width,
      required this.child,
      required this.stackHeight,
      required this.stackWidth,
      this.stackChild,
      required this.headingText,
      required this.playText,
      required this.timeText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 20),
      height: height,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Stack(children: [
        Positioned(
            right: 5,
            top: 5,
            bottom: 5,
            child: Container(
              height: stackHeight,
              width: stackWidth,
              child: stackChild,
            )),
        Positioned(
            left: 10,
            top: 10,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headingText!,
                    softWrap: true,
                    style: AppTextStyle.headline3,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        playText!,
                        style: AppTextStyle.caption,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        timeText!,
                        style: AppTextStyle.caption,
                      )
                    ],
                  ),
                ],
              ),
            ))
      ]),
    );
  }
}
