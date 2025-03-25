import 'package:flutter/material.dart';

class AppColor {
  static const Color primary = Colors.orange;
  static const Color secondary = Colors.orangeAccent;
  static const Color background = Colors.black54;
  static const Color surface = Colors.black87;
  static const Color error = Colors.red;
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onSurface = Colors.white;
  static const Color onError = Colors.white;
  
  static final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface
  );
}