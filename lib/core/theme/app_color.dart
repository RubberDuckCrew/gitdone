import 'package:flutter/material.dart';

/// A class that defines the color scheme for the application.
class AppColor {
  /// Private constructor to prevent instantiation.
  static final colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF6A00),
    onPrimary: Colors.white,
    secondary: Color(0xFF0095FF),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.grey[900]!,
    onSurface: Colors.white,
    surfaceContainer: Colors.grey[800]!,
    secondaryContainer: Color(0xFFFF6A00),
  );
}
