import "package:flutter/material.dart";

/// Singleton class for navigation throughout the app lifecycle.
class Navigation {
  /// GlobalKey for the navigator state.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Navigates to a new [page].
  static Future<dynamic> navigate(final Widget page) async =>
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => page));

  /// Navigates to a new [page] and removes all previous pages from the stack.
  static Future<dynamic> navigateClean(final Widget page) async =>
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (final context) => page),
        (final route) => false,
      );

  /// Navigates back to the previous page.
  /// [result] is optional and can be passed to the previous screen.
  static void navigateBack([final Object? result]) {
    if (hasBack()) {
      navigatorKey.currentState?.pop(result);
    }
  }

  /// Checks if there is a previous screen to navigate back to.
  static bool hasBack() => navigatorKey.currentState?.canPop() ?? false;

  /// Replaces the current screen with [page].
  static Future<dynamic> navigateReplace(final Widget page) async =>
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => page),
      );
}
