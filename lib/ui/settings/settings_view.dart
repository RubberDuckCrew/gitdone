import 'package:flutter/material.dart';
import 'package:gitdone/ui/settings/widgets/repository_selector.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: RepositorySelector());
  }
}
