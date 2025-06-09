import "package:flutter/material.dart";

/// Singleton class for navigation throughout the app lifecycle.
class Navigation {
  /// GlobalKey for the navigator state.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Navigates back to the previous screen.
  ///
  /// [popValue] is optional and can be passed to the previous screen.
  static void goBack([final Object? popValue]) =>
      navigatorKey.currentState?.pop(popValue);

  /// Navigates to a new [page].
  static Future<dynamic> go(final Widget page) async =>
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => page));

  /// Replaces the current screen with [page].
  static Future<dynamic> replace(final Widget page) async => navigatorKey
      .currentState
      ?.pushReplacement(MaterialPageRoute(builder: (_) => page));
}
