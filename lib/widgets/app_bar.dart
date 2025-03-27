import 'package:flutter/material.dart';

class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NormalAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text("GitDone"),
    );
  }

  @override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
