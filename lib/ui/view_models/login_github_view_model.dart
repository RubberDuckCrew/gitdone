import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitdone/utility/github_oauth_handler.dart';

class LoginGithubViewModel extends ChangeNotifier {
  final GitHubAuth githubAuth;
  final BuildContext context;

  /// Creates an instance of [LoginGithubViewModel].
  LoginGithubViewModel({required this.context})
      : githubAuth = GitHubAuth(callbackFunction: (text) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(text), duration: Duration(seconds: 2)));
        });
  bool get inLoginProcess => githubAuth.inLoginProcess;

  /// Starts the login process and returns the user code.
  ///
  /// Returns the `userCode` to be displayed to the user.
  Future<String?> startLogin() async {
    return await githubAuth.startLoginProcess();
  }

  /// Launches the browser and copies the user code to the clipboard.
  void launchBrowser(String userCode) async {
    Clipboard.setData(ClipboardData(text: userCode));
    githubAuth.launchBrowser();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
  }

  /// Continues the login process by polling for the token and executing the
  /// provided callbacks.
  Future<void> continueLogin(
      {required VoidCallback onSuccess,
      required VoidCallback onFailure}) async {
    final authenticated = await githubAuth.pollForToken();
    if (context.mounted) Navigator.of(context).maybePop();
    if (authenticated) {
      onSuccess();
    } else {
      onFailure();
    }
  }

  /// Resets the GitHub authentication handler.
  void disposeHandler() {
    githubAuth.resetHandler();
  }
}
