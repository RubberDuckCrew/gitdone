import 'package:flutter/material.dart';
import 'package:gitdone/widgets/github_login_button.dart';

import '../widgets/app_bar.dart';

class LoginGithubView extends StatefulWidget {
  const LoginGithubView({super.key});

  @override
  State<LoginGithubView> createState() => _LoginGithubViewState();
}

class _LoginGithubViewState extends State<LoginGithubView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [GithubLoginButton()],
        ),
      ),
    );
  }
}
