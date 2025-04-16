import 'package:flutter/material.dart';
import 'package:gitdone/core/theme/app_color.dart';

class PageTitleWidget extends StatelessWidget {
  final String title;

  const PageTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  color: AppColor.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: 16)),
      ],
    );
  }
}
