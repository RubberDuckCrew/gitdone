import "package:flutter/material.dart";
import "package:gitdone/ui/login/oauth/login_oauth_view.dart";
import "package:gitdone/ui/login/oauth/login_oauth_view_model.dart";
import "package:provider/provider.dart";

/// A screen for logging in with GitHub OAuth.
class LoginGithubScreen extends StatelessWidget {
  /// Creates a screen for logging in with GitHub OAuth.
  const LoginGithubScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
    create: (_) => LoginGithubViewModel(),
    child: const LoginGithubView(),
  );
}
