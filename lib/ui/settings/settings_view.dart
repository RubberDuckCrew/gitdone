// This ignore is necessary to avoid issues with the implementation
// ignore_for_file: implementation_imports

import "package:flutter/material.dart";
import "package:gitdone/app_config.dart";
import "package:gitdone/core/models/current_user_model.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/settings/widgets/repository_selector/repository_selector_view.dart";
import "package:github_flutter/src/models/users.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

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
          children: [
            Text("Todo Storage", style: Theme.of(context).textTheme.titleLarge),
            const Text(
              "Select the repository, where you want to store your todos:",
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const RepositorySelector(),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Text(
              "Account Management",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text("Logged in as: "),
            ChangeNotifierProvider(
              create: (_) => SettingsViewModel(),
              child: Consumer<SettingsViewModel>(
                builder:
                    (final context, final model, final child) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (model.avatarUrl.isNotEmpty)
                              CircleAvatar(
                                backgroundImage: NetworkImage(model.avatarUrl),
                                radius: 20,
                              )
                            else
                              const Icon(Icons.account_circle, size: 40),
                            const Padding(padding: EdgeInsets.all(2)),
                            Text(
                              model.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(4)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                              ),
                              onPressed:
                                  () => launchUrl(Uri.parse(model.htmlUrl)),
                              icon: const Icon(
                                Icons.account_circle_outlined,
                                size: 18,
                              ),
                              label: const Text("Profile"),
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
                      ],
                    ),
              ),
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

/// A ViewModel for managing settings-related data and actions.
class SettingsViewModel extends ChangeNotifier {
  /// Creates an instance of [SettingsViewModel] and initializes it.
  SettingsViewModel() {
    _init();
  }

  /// The unique identifier for this class, used for logging.
  static const String classId =
      "com.GitDone.gitdone.ui.settings.settings_view_model";

  Future<void> _init() async {
    final User user = await CurrentUserModel.currentUser;
    username = user.login ?? "Unknown User";
    avatarUrl = user.avatarUrl ?? "";
    htmlUrl = user.htmlUrl ?? "";
    notifyListeners();
  }

  /// The username of the currently logged-in user.
  String username = "Loading...";

  /// The URL to the user's avatar image.
  String avatarUrl = "";

  /// The URL to the user's GitHub profile.
  String htmlUrl = "";
}
