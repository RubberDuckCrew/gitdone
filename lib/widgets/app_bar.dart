import 'package:flutter/material.dart';
import 'package:gitdone/scheme/app_color.dart';
import 'package:gitdone/widgets/app_title.dart';

class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NormalAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const AppTitleWidget(fontSize: 30),
      backgroundColor: AppColor.colorScheme.surfaceContainer,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
