import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gitdone/utility/token_handler.dart';
import 'package:gitdone/widgets/github_code_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

class GitHubAuth {
  final String clientId = "Ov23li2QBbpgRa3P0GHJ";
  final tokenHandler = TokenHandler();
  bool inLoginProcess = false;
  Map<String, dynamic>? _result;

  Future<void> startLoginProcess(BuildContext context) async {
    _result ??= <String, dynamic>{};

    final response = await http.post(
      Uri.parse("https://github.com/login/device/code"),
      headers: {"Accept": "application/json"},
      body: {"client_id": clientId, "scope": "repo user"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _result?['deviceCode'] = data["device_code"];
      _result?['userCode'] = data["user_code"];
      _result?['verificationUri'] = data["verification_uri"];
      _result?['interval'] = data["interval"];

      if (context.mounted) {
        await showGitHubCodeDialog(context, _result?["userCode"]);
      }

      inLoginProcess = true;
      await launchUrlString(
          "${_result?['verificationUri']}?user_code=${_result?['userCode']}",
          mode: LaunchMode.inAppBrowserView);
    } else {
      developer.log("Could not retrieve oauth information from GitHub",
          name: "com.GitDone.gitdone.github_oauth_handler",
          level: 900,
          error: jsonEncode(response.body));
    }
  }

  Future<void> showGitHubCodeDialog(
      BuildContext context, String userCode) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return GithubCodeDialog(userCode: userCode);
      },
    );
  }

  Future<bool> pollForToken() async {
    int attempts = 0;

    if (_result == null) {
      developer.log("pollForToken called with result being null",
          level: 900, name: "com.GitDone.gitdone.github_oauth_handler");
      return false;
    }

    while (true && attempts < 10) {
      await Future.delayed(Duration(seconds: interval));
      http.Client client = http.Client();
      try {
        final response = await client.post(
          Uri.https("github.com", "/login/oauth/access_token"),
          headers: {"Accept": "application/json"},
          body: {
            "client_id": clientId,
            "device_code": deviceCode,
            "grant_type": "urn:ietf:params:oauth:grant-type:device_code"
          },
        );
        client.close();

        if (await _retrieveDataFromResponse(response)) {
          developer.log("Successfully retrieved access token",
              name: "com.GitDone.gitdone.github_oauth_handler");
          return true;
        }
      } catch (e) {
        developer.log("Unexpected error occurred while polling for token",
            name: "com.GitDone.gitdone.github_oauth_handler",
            level: 1000,
            error: jsonEncode(e));
      }
      attempts++;
    }
    return false;
  }

  Future<void> resetHandler() async {
    _result = null;
    inLoginProcess = false;
    developer.log("GitHubAuthHandler reset",
        name: "com.GitDone.gitdone.github_oauth_handler");
  }

  Future<bool> _retrieveDataFromResponse(http.Response response) async {
    var data = jsonDecode(response.body);
    if (data.containsKey("access_token")) {
      await tokenHandler.saveToken(data["access_token"]);
      return true;
    } else {
      developer.log("Error retrieving access token",
          level: 900,
          name: "com.GitDone.gitdone.github_oauth_handler",
          error: jsonEncode(data));
      return false;
    }
  }

  int get interval => _result?['interval'] ?? 0;
  String get deviceCode => _result?['deviceCode'] ?? "";
}
