import "package:gitdone/core/models/token_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";
import "package:url_launcher/url_launcher.dart";

/// This class handles the GitHub OAuth authentication process .
class GitHubAuth {
  /// Creates an instance of GitHubAuth with a callback function.
  GitHubAuth(this.callbackFunction)
    : _deviceFlow = DeviceFlow(clientId, scopes: ["repo", "user"]);

  /// The client ID for the GitHub OAuth application.
  static const clientId = "Ov23li2QBbpgRa3P0GHJ";

  /// The class identifier for logging purposes.
  static const classId = "com.GitDone.gitdone.core.models.github_oauth_handler";

  final _tokenHandler = TokenHandler();
  bool inLoginProcess = false;
  bool _authenticated = false;
  final int _maxLoginAttempts = 2;
  int _attempts = 1;
  Function(String) callbackFunction;
  final DeviceFlow _deviceFlow;
  String? _userCode;

  /// Starts the GitHub OAuth login process.
  Future<String> startLoginProcess() async {
    Logger.log("Starting GitHub login process", classId, LogLevel.finest);

    try {
      _userCode = await _deviceFlow.fetchUserCode();
      inLoginProcess = true;
      Logger.log(
        "Could retrieve oauth information from GitHub",
        classId,
        LogLevel.finest,
      );
      return _userCode ?? "";
    } catch (e) {
      Logger.log(
        "Could not retrieve oauth information from GitHub",
        classId,
        LogLevel.warning,
        error: e,
      );
      return "";
    }
  }

  /// Launches the browser to the GitHub OAuth authorization URL.
  Future<void> launchBrowser() async {
    final String url = _deviceFlow.createAuthorizeUrl();
    if (await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      Logger.log("Launching URL: $url", classId, LogLevel.finest);
    } else {
      Logger.log("Could not launch URL: $url", classId, LogLevel.warning);
    }
  }

  /// Polls for the access token using the user code.
  Future<bool> pollForToken() async {
    _attempts = 1;
    int interval = 0;

    if (userCode.isEmpty) {
      Logger.log(
        "pollForToken called with result being null",
        classId,
        LogLevel.warning,
      );
      return false;
    }

    while (_attempts <= _maxLoginAttempts) {
      DeviceFlowExchangeResponse response;
      try {
        response = await _deviceFlow.exchange();

        if (response.token != null) {
          _tokenHandler.saveToken(response.token!);

          Logger.log(
            "Successfully retrieved access token",
            classId,
            LogLevel.finest,
          );
          inLoginProcess = false;
          _authenticated = true;
          return true;
        } else {
          interval = response.interval;
        }
      } catch (e) {
        Logger.logError(
          "Unexpected error occurred while polling for token",
          classId,
          e,
        );
      }
      await Future.delayed(Duration(seconds: interval));
      _attempts++;
    }
    if (_attempts >= _maxLoginAttempts) {
      Logger.log(
        "Exceeded maximum attempts to poll for token",
        classId,
        LogLevel.warning,
      );
    }
    return false;
  }

  Future<void> resetHandler() async {
    inLoginProcess = false;
    Logger.log("GitHubAuthHandler reset", classId, LogLevel.finest);
  }

  /// Returns the user code for the OAuth process.
  String get userCode => _userCode ?? "";

  /// Returns whether the user is authenticated.
  bool get isAuthenticated => _authenticated;
}
