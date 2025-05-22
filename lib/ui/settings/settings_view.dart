import 'package:flutter/material.dart';
import 'package:gitdone/ui/settings/widgets/repository_selector/repository_selector_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "Select the repository, where you want to store your todos:",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: RepositorySelector(),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
