import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gitdone/ui/welcome/welcome_view.dart';

/// A class to handle token storage and retrieval using Flutter Secure Storage.
class TokenHandler {
  /// Singleton instance of [TokenHandler].
  TokenHandler();
  // TODO(everyone): @VisibleForTesting
  FlutterSecureStorage storage = const FlutterSecureStorage();

  /// Saves the provided token to secure storage.
  Future<void> saveToken(final String token) async {
    await storage.write(key: "auth_token", value: token);
  }

  /// Retrieves the token from secure storage.
  Future<String?> getToken() => storage.read(key: "auth_token");

  /// Deletes the token from secure storage.
  Future<void> deleteToken() async {
    await storage.delete(key: "auth_token");
  }

  /// Checks if a token exists in secure storage.
  Future<bool> hasToken() async {
    final String? token = await storage.read(key: "auth_token");
    return token != null;
  }

  /// Logs out the user by deleting the token and navigating to the welcome view
  static Future<void> logout(final BuildContext context) async {
    final tokenHandler = TokenHandler();
    await tokenHandler.deleteToken();
    // TODO(IamPekka058): Guard Check
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (final context) => const WelcomeView()),
    );
  }
}
