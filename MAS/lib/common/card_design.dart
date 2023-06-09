import 'package:flutter/material.dart';
import 'text_style.dart';

class CommonSingleCard extends StatelessWidget {
  const CommonSingleCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Card(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10.0, left: 20, bottom: 10, right: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Courses and singless",
                      style: AppTextStyle.headline3,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Guided meditation for any moment",
                      style: AppTextStyle.subtitle2,
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Image.asset(
                  "assets/profile.jpg",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
