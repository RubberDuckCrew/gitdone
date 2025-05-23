import 'package:flutter/material.dart';
import 'package:gitdone/app_config.dart';
import 'package:gitdone/core/models/current_user_model.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/ui/_widgets/page_title.dart';
import 'package:gitdone/ui/settings/widgets/repository_selector/repository_selector_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                style: Theme.of(context).textTheme.titleLarge,
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
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text("Logged in as: "),
              ChangeNotifierProvider(
                create: (_) => SettingsViewModel(),
                child: Consumer<SettingsViewModel>(
                  builder: (context, model, child) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            model.avatarUrl.isNotEmpty
                                ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    model.avatarUrl,
                                  ),
                                  radius: 20,
                                )
                                : const Icon(Icons.account_circle, size: 40),
                            const Padding(padding: EdgeInsets.all(2.0)),
                            Text(
                              model.username,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(4.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                              ),
                              onPressed:
                                  () async =>
                                      await launchUrl(Uri.parse(model.htmlUrl)),
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
                    );
                  },
                ),
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

class SettingsViewModel extends ChangeNotifier {
  static final String classId =
      "com.GitDone.gitdone.ui.settings.settings_view_model";

  SettingsViewModel() {
    init();
  }

  Future<void> init() async {
    final user = await CurrentUserModel.currentUser;
    username = user.login ?? "Unknown User";
    avatarUrl = user.avatarUrl ?? "";
    htmlUrl = user.htmlUrl ?? "";
    notifyListeners();
  }

  String username = "Loading...";
  String avatarUrl = "";
  String htmlUrl = "";
}
