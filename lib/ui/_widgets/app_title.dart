import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/theme/app_color.dart";

/// A widget that displays the application title with a specific font size.
class AppTitleWidget extends StatelessWidget {
  /// Creates an instance of [AppTitleWidget] with the specified font size.
  const AppTitleWidget({required this.fontSize, super.key});
  final double fontSize;

  @override
  Widget build(final BuildContext context) => Row(
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

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty("fontSize", fontSize));
  }
}
