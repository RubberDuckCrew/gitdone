import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/core/utils/logger.dart';
import 'package:github_flutter/github.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubAuth {
  static const String clientId = "Iv23liytEkcJOjMjS9No";
  static const String classId =
      "com.GitDone.gitdone.core.models.github_oauth_handler";
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

  Future<void> launchBrowser() async {
    String url = _deviceFlow.createAuthorizeUrl();
    if (await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      Logger.log("Launching URL: $url", classId, LogLevel.finest);
    } else {
      Logger.log("Could not launch URL: $url", classId, LogLevel.warning);
    }
  }

  Future<bool> pollForToken() async {
    attempts = 1;
    int interval = 0;

    if (userCode.isEmpty) {
      Logger.log(
        "pollForToken called with result being null",
        classId,
        LogLevel.warning,
      );
      return false;
    }

    while (attempts <= maxLoginAttempts) {
      DeviceFlowExchangeResponse response;
      try {
        response = await _deviceFlow.exchange();

        if (response.token != null) {
          tokenHandler.saveToken(response.token!);

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
      attempts++;
    }
    if (attempts >= maxLoginAttempts) {
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

  String get userCode => _userCode ?? "";

  bool get isAuthenticated => _authenticated;
}
