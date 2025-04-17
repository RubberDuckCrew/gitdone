import 'dart:developer' as developer;

import 'package:gitdone/core/models/token_handler.dart';
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
    developer.log("Starting GitHub login process",
        level: 300, name: "com.GitDone.gitdone.github_oauth_handler");

    try {
      _userCode = await _deviceFlow.fetchUserCode();
      inLoginProcess = true;
      developer.log("Could retrieve oauth information from GitHub",
          name: "com.GitDone.gitdone.github_oauth_handler", level: 300);
      return _userCode ?? "";
    } catch (e) {
      developer.log("Could not retrieve oauth information from GitHub",
          name: "com.GitDone.gitdone.github_oauth_handler",
          level: 900,
          error: e);
      return "";
    }
  }

  Future<void> launchBrowser() async {
    String url = _deviceFlow.createAuthorizeUrl();
    if (await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      developer.log("Launching URL: $url",
          name: "com.GitDone.gitdone.github_oauth_handler", level: 300);
    } else {
      developer.log("Could not launch URL: $url",
          name: "com.GitDone.gitdone.github_oauth_handler", level: 900);
    }
  }

  Future<bool> pollForToken() async {
    attempts = 1;
    int interval = 0;

    if (userCode.isEmpty) {
      developer.log("pollForToken called with result being null",
          level: 900, name: "com.GitDone.gitdone.github_oauth_handler");
      return false;
    }

    while (true && attempts <= maxLoginAttempts) {
      DeviceFlowExchangeResponse response;
      try {
        response = await _deviceFlow.exchange();

        if (response.token != null) {
          tokenHandler.saveToken(response.token!);

          developer.log("Successfully retrieved access token",
              level: 300, name: "com.GitDone.gitdone.github_oauth_handler");
          inLoginProcess = false;
          _authenticated = true;
          return true;
        } else {
          interval = response.interval;
        }
      } catch (e) {
        developer.log("Unexpected error occurred while polling for token",
            name: "com.GitDone.gitdone.github_oauth_handler",
            level: 1000,
            error: e);
      }
      await Future.delayed(Duration(seconds: interval));
      attempts++;
    }
    if (attempts >= maxLoginAttempts) {
      developer.log("Exceeded maximum attempts to poll for token",
          level: 900, name: "com.GitDone.gitdone.github_oauth_handler");
    }
    return false;
  }

  Future<void> resetHandler() async {
    inLoginProcess = false;
    developer.log("GitHubAuthHandler reset",
        level: 300, name: "com.GitDone.gitdone.github_oauth_handler");
  }

  String get userCode => _userCode ?? "";

  bool get isAuthenticated => _authenticated;
}
