import "dart:convert";
import "dart:math";

import "package:crypto/crypto.dart";
import "package:flutter/services.dart";
import "package:flutter_web_auth_2/flutter_web_auth_2.dart";
import "package:gitdone/core/exceptions/oauth_exception.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";

// TODO(everyone): Add AuthenticationExceptionType to exceptions
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

  static const _classId = "com.GitDone.gitdone.core.models.github_auth";

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

  bool _authenticated = false;
  final OAuth2PKCE _oauth;
  String? _userCode;

  final String _codeVerifier;
  String _codeChallenge = "";

  /// Handles the authentication process with GitHub OAuth.
  /// This method initiates the OAuth flow and returns the authorization code.
  Future<String> authenticate() async {
    inLoginProcess = true;
    _codeChallenge = _sha256FromString(_codeVerifier);
    String result;
    try {
      result = await FlutterWebAuth2.authenticate(
        url: _oauth.createAuthorizeUrl(_codeChallenge),
        callbackUrlScheme: "gitdone",
      );
    } on PlatformException {
      throw OAuthException(errorType: AuthenticationErrorType.userCancelled);
    }

    final String code = _validateAuthenticationResult(result);

    return code;
  }

  /// Completes the login process by exchanging the authorization code for an access token.
  Future<bool> completeLogin(final String userCode) async {
    int tries = 0;
    const int maxTries = 3;

    if (inLoginProcess) {
      while (tries <= maxTries) {
        tries++;
        ExchangeResponse response;
        try {
          response = await _sendExchangeRequest(userCode);
        } catch (_, _) {
          rethrow;
        }

        try {
          _validateExchangeResponse(response);
          _successCallback(response.token!);
          return true;
        } on OAuthException catch (_, _) {
          Logger.log(
            "Login attempt $tries failed. Retrying...",
            _classId,
            LogLevel.warning,
          );
          if (tries >= maxTries) {
            Logger.log(
              "Max retries reached. Login failed.",
              _classId,
              LogLevel.warning,
            );
            return false;
          }
        }
      }
    } else {
      Logger.log(
        "Login process is not active. Cannot complete login.",
        _classId,
        LogLevel.warning,
      );
    }
    return false;
  }

  void _successCallback(final String token) {
    Logger.log(
      "Login completed successfully with token!",
      _classId,
      LogLevel.finest,
    );
    TokenHandler().saveToken(token);
    _authenticated = true;
    inLoginProcess = false;
  }

  /// Validates the response from the exchange request.
  /// Throws an [OAuthException] if the token is null or empty.
  void _validateExchangeResponse(final ExchangeResponse response) {
    if (response.token == null || response.token!.isEmpty) {
      Logger.log(
        "Authentication failed: No token received",
        _classId,
        LogLevel.shout,
      );
      inLoginProcess = false;
      throw OAuthException(errorType: AuthenticationErrorType.noTokenReceived);
    } else {
      Logger.log("Token received successfully", _classId, LogLevel.finest);
    }
  }

  /// Validates the authentication result and extracts the authorization code.
  /// Throws an [OAuthException] if the code is missing or empty.
  String _validateAuthenticationResult(final String result) {
    final String? code = Uri.parse(result).queryParameters["code"];
    if (code == null || code.isEmpty) {
      Logger.log(
        "Authentication failed: No code received",
        _classId,
        LogLevel.shout,
      );
      inLoginProcess = false;
      // TODO(everyone): Discuss error type
      throw OAuthException(
        errorType: AuthenticationErrorType.noUserCodeReceived,
        message: "No code received from authentication",
      );
    }
    Logger.log("Authentication successful", _classId, LogLevel.finest);
    return code;
  }

  Future<ExchangeResponse> _sendExchangeRequest(final String code) async {
    final ExchangeResponse response = await _oauth
        .exchange(code, _codeVerifier)
        .onError((final error, final stackTrace) {
          Logger.log(
            "Error during token exchange: $error",
            _classId,
            LogLevel.shout,
          );
          // TODO(everyone): Discuss error type
          throw OAuthException(
            message: "Failed to exchange code for token",
            errorType: AuthenticationErrorType.serverError,
          );
        });
    return response;
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
