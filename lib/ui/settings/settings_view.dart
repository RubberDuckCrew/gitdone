import "package:flutter/material.dart";
import "package:gitdone/app_config.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/settings/widgets/account_management.dart";
import "package:gitdone/ui/settings/widgets/repository_selector/repository_selector_view.dart";

/// A view that displays settings and allows users to manage their account and repository preferences.
class SettingsView extends StatelessWidget {
  /// Creates an instance of [SettingsView].
  const SettingsView({super.key});

  @override
  Widget build(final BuildContext context) => Column(
    children: [
      const PageTitleWidget(title: "Settings"),
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task Storage",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Text(
                  "Select the repository, where you want to store your tasks:",
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const RepositorySelector(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account Management",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Text("Logged in as:"),
                const AccountManagement(),
              ],
            ),
          ],
        ),
      ),
      const Spacer(),
      Column(
        children: [
          const Text(
            "GitDone is not affiliated with GitHub, Inc.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            "Version: ${AppConfig.version} (${AppConfig.gitCommit}, ${AppConfig.flavor})",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Padding(padding: EdgeInsets.all(8)),
        ],
      ),
    ],
  );
}

