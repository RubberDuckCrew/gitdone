import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:gitdone/app_environment.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/_widgets/app_title.dart";
import "package:gitdone/ui/login/oauth/login_oauth_screen.dart";
import "package:gitdone/ui/login/token/login_token_view.dart";

/// A view that displays the welcome screen of the application.
class WelcomeView extends StatefulWidget {
  /// Creates a welcome view that prompts the user to log in with GitHub.
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(final BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        children: [
          const Spacer(flex: 1),
          Expanded(
            flex: 2,
            child: SvgPicture.asset("assets/icons/app/gitdone.svg"),
          ),
          const AppTitleWidget(fontSize: 45),
          const Text(
            "Store your todos in GitHub issues",
            style: TextStyle(fontSize: 20),
          ),
          const Spacer(flex: 1),
          const Text(
            "To use GitDone, please login with your GitHub account",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          FilledButton(
            onPressed: goToLoginGithubView,
            child: const Text("Login with GitHub"),
          ),
          const Text("or"),
          FilledButton(
            onPressed: goToLoginTokenView,
            child: const Text("Enter Personal Access Token"),
          ),
          const Spacer(flex: 1),
          const Text(
            "GitDone is not affiliated with GitHub, Inc.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            "Version: ${AppEnvironment.version} (${AppEnvironment.gitCommit}, ${AppEnvironment.flavor})",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Padding(padding: EdgeInsets.all(10)),
        ],
      ),
    ),
  );

  void goToLoginGithubView() => Navigation.navigate(const LoginGithubScreen());

  void goToLoginTokenView() => Navigation.navigate(const LoginTokenView());
}
