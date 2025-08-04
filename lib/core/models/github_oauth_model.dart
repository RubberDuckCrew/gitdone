import "dart:convert";
import "dart:math";
import "dart:typed_data";

import "package:crypto/crypto.dart";
import "package:flutter_web_auth_2/flutter_web_auth_2.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";

/// This class handles the GitHub OAuth authentication process .
class GitHubAuth {
  /// Creates an instance of GitHubAuth with a callback function.
  GitHubAuth(this.callbackFunction)
    : _oauth = OAuth2PKCE(
        clientId,
        "https://gitdone-cloudflare-worker.rubberduckcrew.workers.dev/",
        scopes: ["repo", "user"],
        redirectUri: "gitdone://callback",
      ),
      _codeVerifier = _randomCodeVerifier(64);

  /// The client ID for the GitHub OAuth application.
  static const clientId = "Ov23li2QBbpgRa3P0GHJ";

  static const _classId =
      "com.GitDone.gitdone.core.models.github_oauth_handler";

  static String _randomCodeVerifier(final int length) {
    const chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  static String _sha256FromString(final String input) {
    final Uint8List bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    final String base64Digest = base64Url
        .encode(digest.bytes)
        .replaceAll("=", "");
    return base64Digest;
  }

  /// Indicates whether the login process is currently active.
  bool inLoginProcess = false;

  /// A callback function to be executed after the login process.
  Function(String) callbackFunction;

  final bool _authenticated = false;
  final OAuth2PKCE _oauth;
  String? _userCode;

  final String _codeVerifier;
  String _codeChallenge = "";

  /// Handles the authentication process with GitHub OAuth.
  /// This method initiates the OAuth flow and returns the authorization code.
  Future<String> authenticate() async {
    _codeChallenge = _sha256FromString(_codeVerifier);

    final String result = await FlutterWebAuth2.authenticate(
      url: _oauth.createAuthorizeUrl(_codeChallenge),
      callbackUrlScheme: "gitdone",
    );

    final String? code = Uri.parse(result).queryParameters["code"];
    if (code == null || code.isEmpty) {
      Logger.log(
        "Authentication failed: No code received",
        _classId,
        LogLevel.warning,
      );
      throw Exception("No code received from authentication");
    }

    Logger.log("Authentication successful", _classId, LogLevel.finest);
    return code;
  }

  /// Resets the login process state.
  Future<void> resetHandler() async {
    inLoginProcess = false;
    Logger.log("GitHubAuthHandler reset", _classId, LogLevel.finest);
  }

  /// Returns the user code for the OAuth process.
  String get userCode => _userCode ?? "";

  /// Returns whether the user is authenticated.
  bool get isAuthenticated => _authenticated;
}
