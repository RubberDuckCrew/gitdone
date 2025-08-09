import "package:flutter/material.dart";
import "package:gitdone/core/exceptions/oauth_exception.dart";
import "package:gitdone/core/models/github_oauth_model.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/main_screen.dart";

/// ViewModel for managing the login process using GitHub OAuth.
class LoginGithubViewModel extends ChangeNotifier {
  /// Creates an instance of [LoginGithubViewModel].
  LoginGithubViewModel() : _githubAuth = GitHubAuth((final info) {});
  final GitHubAuth _githubAuth;

  static const String _classId =
      "com.GitDone.gitdone.ui.login.oauth.login_oauth_view_model";

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
      await _githubAuth.completeLogin(userCode);
    } on OAuthException catch (error) {
      _handleError(error);
      return;
    }

    Navigation.navigate(const MainScreen());
  }

  /// Retries the login process after an error has occurred.
  Future<void> retry() async {
    _errorOccurred = false;
    errorMessage = "";
    notifyListeners();
    await startLogin();
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
            "GitHub reported an invalid grant. This is likely due to errors within our confidential intermediary server. Please try again. If the problem persists, please contact us. [Error Type: invalidGrant]";

      case AuthenticationErrorType.badVerificationCode:
        errorMessage =
            "GitHub reported a bad verification code. Please try again. If the problem persists, please contact us. [Error Type: badVerificationCode]";
      case AuthenticationErrorType.loginProcessNotActive:
        errorMessage =
            "This looks like an internal error on our end. Please contact us. [Error Type: loginProcessNotActive]";
      case AuthenticationErrorType.maxRetriesReached:
        errorMessage =
            "The maximum number of retries has been reached. Check your internet connection and try again . [Error Type: maxRetriesReached]";
    }
    notifyListeners();
    Logger.log("Received: $error", _classId, LogLevel.warning);
  }
}
