import 'package:flutter/material.dart';
import 'package:gitdone/core/theme/app_color.dart';

class AppTitleWidget extends StatelessWidget {
  final double fontSize;

  const AppTitleWidget({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Git",
          style: TextStyle(
            fontSize: fontSize,
            color: AppColor.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Done",
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
