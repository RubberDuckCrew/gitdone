import "dart:convert";
import "dart:math";
import "dart:typed_data";

import "package:crypto/crypto.dart";
import "package:flutter_web_auth_2/flutter_web_auth_2.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/main_screen.dart";
import "package:github_flutter/github.dart";
import "package:url_launcher/url_launcher.dart";

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

  final _tokenHandler = TokenHandler();
  bool _authenticated = false;
  final int _maxLoginAttempts = 2;
  int _attempts = 1;
  final OAuth2PKCE _oauth;
  String? _userCode;

  final String _codeVerifier;
  String _codeChallenge = "";

  /*
  /// Starts the GitHub OAuth login process.
  Future<String> startLoginProcess() async {
    Logger.log("Starting GitHub login process", _classId, LogLevel.finest);

    try {
      _userCode = await _oauth.fetchUserCode();
      inLoginProcess = true;
      Logger.log(
        "Could retrieve oauth information from GitHub",
        _classId,
        LogLevel.finest,
      );
      return _userCode ?? "";
    } on Exception catch (e) {
      Logger.log(
        "Could not retrieve oauth information from GitHub",
        _classId,
        LogLevel.warning,
        error: e,
      );
      return "";
    }
  }*/

  /// Launches the browser to the GitHub OAuth authorization URL.
  Future<void> launchBrowser() async {
    _codeChallenge = _sha256FromString(_codeVerifier);
    final String url = _oauth.createAuthorizeUrl(_codeChallenge);
    if (await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
      Logger.log("Launching URL: $url", _classId, LogLevel.finest);
    } else {
      Logger.log("Could not launch URL: $url", _classId, LogLevel.warning);
    }
  }

  Future<String> authenticate() async {
    _codeChallenge = _sha256FromString(_codeVerifier);
    print(_oauth.createAuthorizeUrl(_codeChallenge));
    final String result = await FlutterWebAuth2.authenticate(
      url: _oauth.createAuthorizeUrl(_codeChallenge),
      callbackUrlScheme: "gitdone",
      options: const FlutterWebAuth2Options(intentFlags: defaultIntentFlags),
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

  /// Polls for the access token using the user code.
  Future<bool> pollForToken(final String code) async {
    // Request to the intermediary server to exchange the user code for an access token
    Logger.log("Polling for token", _classId, LogLevel.finest);
    try {
      final ExchangeResponse response = await _oauth.exchange(
        code,
        _codeVerifier,
      );

      if (response.token != null && response.token!.isNotEmpty) {
        Logger.log("Token received successfully", _classId, LogLevel.finest);
        await _tokenHandler.saveToken(response.token!);
        _authenticated = true;
        inLoginProcess = false;
        callbackFunction("Login successful");
        Navigation.navigateClean(const MainScreen());
        return true;
      } else {
        Logger.log("No access token received", _classId, LogLevel.warning);
      }
    } catch (e) {
      Logger.log("Error during token exchange: $e", _classId, LogLevel.warning);
    }

    return false;
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
