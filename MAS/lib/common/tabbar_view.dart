import 'package:flutter/material.dart';
import 'text_style.dart';

class CommonTabbar extends StatelessWidget {
  const CommonTabbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 80,
                  child: Card(
                    elevation: 5,
                    child: Image.asset(
                      "assets/man.png",
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Brun",
                            style: AppTextStyle.headline2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Meditation",
                                style: AppTextStyle.subtitle1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "-",
                                style: AppTextStyle.subtitle1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "3 min",
                                style: AppTextStyle.subtitle1,
                              )
                            ],
                          ),
                        ]),
                  ),
                )
              ],
            ),
          );
        });
  }
}
