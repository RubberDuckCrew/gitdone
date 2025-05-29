import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/theme/app_color.dart";

/// A widget that displays a page title with a specific style.
class PageTitleWidget extends StatelessWidget {
  /// Creates an instance of [PageTitleWidget] with the given [title].
  const PageTitleWidget({required final String title, super.key})
    : _title = title;

  final String _title;

  @override
  Widget build(final BuildContext context) => Column(
    children: [
      const Padding(padding: EdgeInsets.only(top: 16)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              _title,
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
    properties.add(StringProperty("title", _title));
  }
}
