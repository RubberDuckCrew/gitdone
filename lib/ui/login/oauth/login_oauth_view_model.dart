import "package:flutter/material.dart";
import "package:gitdone/core/models/github_oauth_model.dart";

/// ViewModel for managing the login process using GitHub OAuth.
class LoginGithubViewModel extends ChangeNotifier {
  /// Creates an instance of [LoginGithubViewModel].
  LoginGithubViewModel({required this.infoCallback})
    : _githubAuth = GitHubAuth(infoCallback);
  final GitHubAuth _githubAuth;

  /// Callback function to show the user an informational message.
  Function(String) infoCallback;

  /// Starts the login process and returns the user code.
  ///
  /// Returns the `userCode` to be displayed to the user.
  Future<String?> startLogin() async {
    final String userCode = await _githubAuth.authenticate();

    return userCode;
  }
}
