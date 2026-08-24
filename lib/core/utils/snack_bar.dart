import "package:flutter/material.dart";

/// Utility class for showing Snack bars safely.
class SnackBarUtils {
  /// Shows a SnackBar with the given [message].
  static void show({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
