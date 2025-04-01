import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../utility/github_oauth_handler.dart';
import '../views/home_view.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> with WidgetsBindingObserver {
  final GitHubAuth githubAuth = GitHubAuth();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    githubAuth.resetHandler();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    developer.log("AppLifecycleState changed to: $state",
        name: "com.GitDone.gitdone.login");
    if (state == AppLifecycleState.resumed && githubAuth.inLoginProcess) {
      continueLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
        );
        await githubAuth.startLoginProcess(context);
      },
      child: Text("Mit GitHub einloggen"),
    );
  }

  Future<void> continueLogin() async {
    var authenticated = await githubAuth.pollForToken();
    if (mounted && authenticated) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homeview()));
    }
  }
}
