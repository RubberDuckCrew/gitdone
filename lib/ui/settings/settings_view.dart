import 'package:flutter/material.dart';
import 'package:gitdone/ui/settings/widgets/RepositorySelector.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Repositoryselector());
  }
}
