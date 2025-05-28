import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/theme/app_color.dart";

class PageTitleWidget extends StatelessWidget {
  const PageTitleWidget({required this.title, super.key});
  final String title;

  @override
  Widget build(final BuildContext context) => Column(
    children: [
      const Padding(padding: EdgeInsets.only(top: 16)),
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
      const Padding(padding: EdgeInsets.only(bottom: 16)),
    ],
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty("title", title));
  }
}
