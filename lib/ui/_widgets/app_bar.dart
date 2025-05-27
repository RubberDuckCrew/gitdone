import 'package:flutter/material.dart';
import 'package:gitdone/core/theme/app_color.dart';
import 'package:gitdone/ui/_widgets/app_title.dart';

/// A normal app bar that is used in most of the views.
class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a normal app bar with an optional back button.
  const NormalAppBar({super.key, this.backVisible = true});

  /// Whether the back button should be visible.
  final dynamic backVisible;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const AppTitleWidget(fontSize: 30),
      backgroundColor: AppColor.colorScheme.surfaceContainer,
      leading: (Navigator.canPop(context) && backVisible)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : const SizedBox(width: 48),
      actions: const [SizedBox(width: 48)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
