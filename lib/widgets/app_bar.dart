import 'package:flutter/material.dart';
import 'package:gitdone/scheme/app_color.dart';
import 'package:gitdone/widgets/app_title.dart';

class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic backVisible;

  const NormalAppBar({super.key, this.backVisible = true});

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
          : SizedBox(width: 48),
      actions: [
        const SizedBox(width: 48),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
