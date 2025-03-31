import 'package:flutter/material.dart';
import 'package:gitdone/scheme/app_color.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Git",
        style: TextStyle(
            fontSize: 45,
            color: AppColor.colorScheme.primary,
            fontWeight: FontWeight.bold),
      ),
      Text(
        "Done",
        style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
      )
    ]);
  }
}
