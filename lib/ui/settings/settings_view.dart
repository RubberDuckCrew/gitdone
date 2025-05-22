import 'package:flutter/material.dart';
import 'package:gitdone/app_config.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/ui/_widgets/page_title.dart';
import 'package:gitdone/ui/settings/widgets/repository_selector/repository_selector_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageTitleWidget(title: "Settings"),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Todo Storage",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "Select the repository, where you want to store your todos:",
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RepositorySelector(),
              ),
              const Padding(padding: EdgeInsets.all(8.0)),
              Text(
                "Account Management",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                ),
                onPressed: () => TokenHandler.logout(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text("Logout"),
              ),
            ],
          ),
        ),
        Spacer(),
        Column(
          children: [
            const Text(
              "GitDone is not affiliated with GitHub, Inc.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              "Version: ${AppConfig.version} (${AppConfig.gitCommit}, ${AppConfig.flavor})",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
          ],
        ),
      ],
    );
  }
}
