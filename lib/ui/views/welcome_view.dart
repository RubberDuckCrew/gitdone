import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gitdone/ui/screens/login_github_screen.dart';
import 'package:gitdone/ui/views/login_token_view.dart';
import 'package:gitdone/ui/widgets/app_title.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Spacer(flex: 1),
          Expanded(
              flex: 2,
              child: SvgPicture.asset(
                "assets/icons/app/gitdone.svg",
              )),
          const AppTitleWidget(fontSize: 45),
          const Text("Store your todos in GitHub issues",
              style: TextStyle(fontSize: 20)),
          const Spacer(flex: 1),
          const Text("To use GitDone, please login with your GitHub account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Padding(padding: EdgeInsets.all(8.0)),
          FilledButton(
              onPressed: goToLoginGithubView,
              child: const Text("Login with GitHub")),
          const Text("or"),
          FilledButton(
              onPressed: goToLoginTokenView,
              child: const Text("Enter Personal Access Token")),
          const Spacer(flex: 1),
        ],
      ),
    ));
  }

  void goToLoginGithubView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginGithubScreen()),
    );
  }

  void goToLoginTokenView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginTokenView()),
    );
  }
}
