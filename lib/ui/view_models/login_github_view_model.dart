import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitdone/ui/views/home_view.dart';
import 'package:gitdone/utility/github_oauth_handler.dart';

class LoginGithubViewModel extends ChangeNotifier {
  final GitHubAuth _githubAuth;

  final ValueNotifier<bool> showProgressIndicatorNotifier =
      ValueNotifier(false);
  final ValueNotifier<bool> fetchedUserCode = ValueNotifier(false);

  /// Callback function to show the user an informational message.
  Function(String) infoCallback;

  /// Creates an instance of [LoginGithubViewModel].
  LoginGithubViewModel({required this.infoCallback})
      : _githubAuth = GitHubAuth(callbackFunction: infoCallback);

  bool get inLoginProcess => _githubAuth.inLoginProcess;

  /// Starts the login process and returns the user code.
  ///
  /// Returns the `userCode` to be displayed to the user.
  Future<String?> startLogin() async {
    String? userCode = await _githubAuth.startLoginProcess();
    if (userCode.isNotEmpty) fetchedUserCode.value = true;
    return userCode;
  }

  /// Launches the browser and copies the user code to the clipboard.
  void launchBrowser() async {
    showProgressIndicatorNotifier.value = true;
    Clipboard.setData(ClipboardData(text: _githubAuth.userCode));
    _githubAuth.launchBrowser();
  }

  /// Continues the login process by polling for the token and executing the
  /// provided callbacks.
  Future<void> continueLogin(
      {required VoidCallback onSuccess,
      required VoidCallback onFailure}) async {
    final authenticated = await _githubAuth.pollForToken();

    // Reactively notify the login process state
    showProgressIndicatorNotifier.value = false;

    if (authenticated) {
      onSuccess();
    } else {
      onFailure();
    }
  }

  /// Handles Lifecycle events from the UI
  void handleAppLifecycleState(AppLifecycleState state, BuildContext context) {
    if (state == AppLifecycleState.resumed && inLoginProcess) {
      continueLogin(
        onSuccess: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Homeview()),
            (Route route) => false,
          );
        },
        onFailure: () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
          infoCallback("Login failed. Please try again.");
        },
      );
    }
  }

  /// Resets the GitHub authentication handler.
  void disposeHandler() {
    _githubAuth.resetHandler();
  }

  bool get authenticated => _githubAuth.isAuthenticated;
  String get userCode => _githubAuth.userCode;
}
