import 'package:flutter/material.dart';

import '../utility/github_oauth_handler.dart';
import '../views/home_view.dart';

/*
  Widget to handle the GitHub device flow login.
 */
class GithubLoginButton extends StatefulWidget {
  const GithubLoginButton({super.key});

  @override
  State<GithubLoginButton> createState() => _GithubLoginButtonState();
}

class _GithubLoginButtonState extends State<GithubLoginButton> {
  final GitHubAuth githubAuth = GitHubAuth();

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
        bool result = await githubAuth.login(context);
        if (result) {
          if (context.mounted) {
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => Homeview()));
          }
        }
      },
      child: Text("Login with GitHub"),
    );
  }
}
