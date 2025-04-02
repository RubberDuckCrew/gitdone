import 'package:flutter/material.dart';
import 'package:gitdone/scheme/app_color.dart';

class TitleWidget extends StatelessWidget {
  final double fontSize;

  const TitleWidget({super.key, this.fontSize = 30});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Git",
        style: TextStyle(
            fontSize: fontSize,
            color: AppColor.colorScheme.primary,
            fontWeight: FontWeight.bold),
      ),
      Text(
        "Done",
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      )
    ]);
  }
}
