import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gitdone/utility/token_handler.dart';
import 'package:gitdone/widgets/github_code_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class GitHubAuth {
  final String clientId = "Ov23lifY3CBW4TAInvhW";
  final tokenHandler = TokenHandler();

  Future<bool> login(BuildContext context) async {
    final response = await http.post(
      Uri.parse("https://github.com/login/device/code"),
      headers: {"Accept": "application/json"},
      body: {"client_id": clientId, "scope": "repo user"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final deviceCode = data["device_code"];
      final userCode = data["user_code"];
      final verificationUri = data["verification_uri"];

      if (context.mounted) await _showGitHubCodeDialog(context, userCode);

      if (await canLaunchUrl(
          Uri.parse("$verificationUri?user_code=$userCode"))) {
        await launchUrl(Uri.parse("$verificationUri?user_code=$userCode"));
      }
      return await _pollForToken(deviceCode);
    }
    return false;
  }

  Future<bool> _pollForToken(String deviceCode) async {
    bool success = false;
    while (true) {
      await Future.delayed(Duration(seconds: 10));

      final response = await http.post(
        Uri.parse("https://github.com/login/oauth/access_token"),
        headers: {"Accept": "application/json"},
        body: {
          "client_id": clientId,
          "device_code": deviceCode,
          "grant_type": "urn:ietf:params:oauth:grant-type:device_code"
        },
      );

      final data = jsonDecode(response.body);

      if (data.containsKey("access_token")) {
        await tokenHandler.saveToken(data["access_token"]);
        success = true;
        break;
      } else {
        //TODO: Handle errors
        break;
      }
    }
    return success;
  }

  Future<void> _showGitHubCodeDialog(
      BuildContext context, String userCode) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return GithubCodeDialog(userCode: userCode);
      },
    );
  }
}
