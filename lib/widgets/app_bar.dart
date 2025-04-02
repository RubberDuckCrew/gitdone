import 'package:flutter/material.dart';
import 'package:gitdone/widgets/title.dart';

class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NormalAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const TitleWidget(fontSize: 30),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
