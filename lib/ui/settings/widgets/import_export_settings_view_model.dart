import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitdone/core/settings_handler.dart';
import "package:gitdone/core/utils/snack_bar.dart";

/// ViewModel for importing and exporting settings.
class ImportExportSettingsViewModel extends ChangeNotifier {
  /// Exports settings as JSON and copies them to the clipboard.
  Future<void> exportSettingsToClipboard(final BuildContext context) async {
    try {
      final String json = await SettingsHandler().exportSettings();
      await Clipboard.setData(ClipboardData(text: json));
      if (context.mounted) {
        SnackBarUtils.show(
          context: context,
          message: "Settings copied to clipboard!",
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        SnackBarUtils.show(context: context, message: "Export failed: $e");
      }
    }
  }

  /// Imports settings from JSON string.
  Future<void> importSettingsFromJson(
    final BuildContext context,
    final String json,
  ) async {
    try {
      await SettingsHandler().importSettings(json);
      if (context.mounted) {
        SnackBarUtils.show(
          context: context,
          message: "Settings imported! Restart app for all changes.",
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        SnackBarUtils.show(context: context, message: "Import failed: $e");
      }
    }
  }
}
