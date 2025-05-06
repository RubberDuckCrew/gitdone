import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/core/utils/developer.dart';
import 'package:github_flutter/github.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubAuth {
  static const String clientId = "Iv23liytEkcJOjMjS9No";
  final tokenHandler = TokenHandler();
  bool inLoginProcess = false;
  bool _authenticated = false;
  final int maxLoginAttempts = 2;
  int attempts = 1;
  Function(String) callbackFunction;
  final DeviceFlow _deviceFlow;
  String? _userCode;

  GitHubAuth({required this.callbackFunction})
      : _deviceFlow = DeviceFlow(clientId, scopes: ["repo", "user"]);

  Future<String> startLoginProcess() async {
    Developer.log("Starting GitHub login process",
        "com.GitDone.gitdone.github_oauth_handler", LogLevel.finest);

    try {
      _userCode = await _deviceFlow.fetchUserCode();
      inLoginProcess = true;
      Developer.log("Could retrieve oauth information from GitHub",
          "com.GitDone.gitdone.github_oauth_handler", LogLevel.finest);
      return _userCode ?? "";
    } catch (e) {
      Developer.logWarning("Could not retrieve oauth information from GitHub",
          "com.GitDone.gitdone.github_oauth_handler",
          error: e);
      return "";
    }
  }

  Future<void> launchBrowser() async {
    String url = _deviceFlow.createAuthorizeUrl();
    if (await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      Developer.log("Launching URL: $url",
          "com.GitDone.gitdone.github_oauth_handler", LogLevel.finest);
    } else {
      Developer.logWarning("Could not launch URL: $url",
          "com.GitDone.gitdone.github_oauth_handler");
    }
  }

  Future<bool> pollForToken() async {
    attempts = 1;
    int interval = 0;

    if (userCode.isEmpty) {
      Developer.logWarning("pollForToken called with result being null",
          "com.GitDone.gitdone.github_oauth_handler");
      return false;
    }

    while (true && attempts <= maxLoginAttempts) {
      DeviceFlowExchangeResponse response;
      try {
        response = await _deviceFlow.exchange();

        if (response.token != null) {
          tokenHandler.saveToken(response.token!);

          Developer.log("Successfully retrieved access token",
              "com.GitDone.gitdone.github_oauth_handler", LogLevel.finest);
          inLoginProcess = false;
          _authenticated = true;
          return true;
        } else {
          interval = response.interval;
        }
      } catch (e) {
        Developer.logError("Unexpected error occurred while polling for token",
            "com.GitDone.gitdone.github_oauth_handler", e);
      }
      await Future.delayed(Duration(seconds: interval));
      attempts++;
    }
    if (attempts >= maxLoginAttempts) {
      Developer.logWarning("Exceeded maximum attempts to poll for token",
          "com.GitDone.gitdone.github_oauth_handler");
    }
    return false;
  }

  Future<void> resetHandler() async {
    inLoginProcess = false;
    Developer.log("GitHubAuthHandler reset",
        "com.GitDone.gitdone.github_oauth_handler", LogLevel.finest);
  }

  String get userCode => _userCode ?? "";

  bool get isAuthenticated => _authenticated;
}
