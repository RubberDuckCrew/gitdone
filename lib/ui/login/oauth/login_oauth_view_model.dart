import "package:flutter/material.dart";
import "package:gitdone/core/exceptions/oauth_exception.dart";
import "package:gitdone/core/models/github_oauth_model.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/main_screen.dart";

/// ViewModel for managing the login process using GitHub OAuth.
class LoginGithubViewModel extends ChangeNotifier {
  /// Creates an instance of [LoginGithubViewModel].
  LoginGithubViewModel({required this.infoCallback})
    : _githubAuth = GitHubAuth(infoCallback);
  final GitHubAuth _githubAuth;

  static const String _classId =
      "com.GitDone.gitdone.ui.login.oauth.login_oauth_view_model";

  /// Callback function to show the user an informational message.
  Function(String) infoCallback;

  bool _errorOccurred = false;

  /// Returns whether an error occurred during the login process.
  bool get errorOccurred => _errorOccurred;

  /// The error message to be displayed if an error occurred.
  String errorMessage = "";

  /// Starts the login process and returns the user code.
  ///
  /// Returns the `userCode` to be displayed to the user.
  Future<void> startLogin() async {
    String userCode;
    try {
      userCode = await _githubAuth.authenticate();
    } on OAuthException catch (error) {
      _handleError(error);
      return;
    }

    notifyListeners();

    bool loginResult;

    try {
      loginResult = await _githubAuth.completeLogin(userCode);
    } on OAuthException catch (error) {
      _handleError(error);
      return;
    }

    // TODO(everyone): This should be replaced with exceptions inside completeLogin()
    if (!loginResult) {
      infoCallback("Login failed. Please try again.");
      _errorOccurred = true;
      notifyListeners();
      return;
    }

    Navigation.navigate(const MainScreen());
  }

  /// Returns the current status of the login process.
  String get status {
    if (_githubAuth.inLoginProcess) {
      return "In Progress";
    } else if (_githubAuth.isAuthenticated) {
      return "Authenticated";
    } else {
      return "Not Started";
    }
  }

  void _handleError(final OAuthException error) {
    _errorOccurred = true;

    switch (error.errorType) {
      case AuthenticationErrorType.userCancelled:
        errorMessage =
            "It seems like you cancelled the login process. [Error Type: userCancelled]";

      case AuthenticationErrorType.noTokenReceived:
        errorMessage =
            "Github did not return a token. Please try again. If the problem persists, please contact us. [Error Type: noTokenReceived]";

      case AuthenticationErrorType.noUserCodeReceived:
        errorMessage =
            "Github did not return a user code. Please try again. If the problem persists, please contact us. [Error Type: noUserCodeReceived]";

      case AuthenticationErrorType.serverError:
        errorMessage =
            "An error occurred on the server. Please try again. [Error Type: serverError]";

      case AuthenticationErrorType.invalidGrant:
        errorMessage =
            "GitHub reported an invalid grant. Please try again. If the problem persists, please contact us. [Error Type: invalidGrant]";

      case AuthenticationErrorType.badVerificationCode:
        errorMessage =
            "GitHub reported a bad verification code. Please try again. If the problem persists, please contact us. [Error Type: badVerificationCode]";
    }
    notifyListeners();
    Logger.log("Received OAuthException: $error", _classId, LogLevel.warning);
  }
}
