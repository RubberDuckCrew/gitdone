import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:gitdone/core/models/github_oauth_model.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/main_screen.dart";

/// ViewModel for managing the login process using GitHub OAuth.
class LoginGithubViewModel extends ChangeNotifier {
  /// Creates an instance of [LoginGithubViewModel].
  LoginGithubViewModel({required this.infoCallback})
    : _githubAuth = GitHubAuth(infoCallback);
  final GitHubAuth _githubAuth;

  /// Notifier to show/hide the progress indicator.
  final ValueNotifier<bool> showProgressIndicatorNotifier = ValueNotifier(
    false,
  );

  /// Notifier to hold the fetched user code.
  final ValueNotifier<String> fetchedUserCode = ValueNotifier("");

  /// Callback function to show the user an informational message.
  Function(String) infoCallback;

  /// Starts the login process and returns the user code.
  ///
  /// Returns the `userCode` to be displayed to the user.
  Future<String?> startLogin() async {
    final String userCode = await _githubAuth.startLoginProcess();

    if (userCode.isNotEmpty) {
      fetchedUserCode.value = userCode;
    }
    return userCode;
  }

  /// Launches the browser and copies the user code to the clipboard.
  Future<void> launchBrowser() async {
    showProgressIndicatorNotifier.value = true;
    Clipboard.setData(ClipboardData(text: _githubAuth.userCode));
    _githubAuth.launchBrowser();
  }

  /// Continues the login process by polling for the token and executing the
  /// provided callbacks.
  Future<void> continueLogin({
    required final VoidCallback onSuccess,
    required final VoidCallback onFailure,
  }) async {
    final bool authenticated = await _githubAuth.pollForToken();

    // Notify listeners that the progress indicator should be hidden
    showProgressIndicatorNotifier.value = false;

    if (authenticated) {
      onSuccess();
    } else {
      onFailure();
    }
  }

  /// Handles Lifecycle events from the UI
  void handleAppLifecycleState(
    final AppLifecycleState state,
    final BuildContext context,
  ) {
    if (state == AppLifecycleState.resumed && _githubAuth.inLoginProcess) {
      continueLogin(
        onSuccess: () => Navigation.navigateClean(const MainScreen()),
        onFailure: () {
          Navigation.navigateBack();
          infoCallback("Login failed. Please try again.");
        },
      );
    }
  }

  /// Returns the user code from the GitHub OAuth model.
  String get userCode => _githubAuth.userCode;
}
