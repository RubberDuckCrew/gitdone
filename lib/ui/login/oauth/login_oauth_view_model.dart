import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:gitdone/core/exceptions/authentication_exception.dart";
import "package:gitdone/core/exceptions/oauth_request_exception.dart";
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
    final String userCode = await _githubAuth.authenticate().catchError((
      final error,
      final stackTrace,
    ) {
      _handleError(error);
      return "";
    });

    if (userCode.isEmpty) {
      infoCallback("Login failed. Please try again.");
      _handleError(userCode);
      notifyListeners();
      return;
    }
    final bool loginResult = await _githubAuth
        .completeLogin(userCode)
        .catchError((final error, final stackTrace) {
          _handleError(error);
          return false;
        });

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

  void _handleError(final Object error) {
    _errorOccurred = true;

    if (error.runtimeType == PlatformException) {
      errorMessage = "It seems that you have cancelled the login process.";
    } else if (error.runtimeType == OAuthRequestException) {
      errorMessage =
          "It seems that the Server does not respond. "
          "Please try again later.";
    } else if (error.runtimeType == AuthenticationException) {
      errorMessage =
          "We did not receive a valid response from the server. "
          "Please try again later.";
    } else {
      errorMessage = "An unexpected error occurred.";
    }
    notifyListeners();
    Logger.log(
      "Error in LoginGithubViewModel: $error",
      _classId,
      LogLevel.shout,
    );
  }
}
