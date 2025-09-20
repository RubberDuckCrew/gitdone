import "dart:convert";

import "package:flutter/foundation.dart";
import "package:gitdone/core/models/repository_details.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:shared_preferences/shared_preferences.dart";

/// Enum for all supported settings keys.
enum SettingKey {
  /// Key for storing the selected repository details.
  selectedRepository,
}

/// Centralized handler for application settings.
class SettingsHandler extends ChangeNotifier {
  /// Creates a new instance of [SettingsHandler].
  factory SettingsHandler() => _instance;
  SettingsHandler._internal();
  static final SettingsHandler _instance = SettingsHandler._internal();
  static const _classId = "com.GitDone.gitdone.core.settings_handler";

  SharedPreferences? _prefs;

  /// Initializes the settings handler. Must be called before usage.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
    Logger.log("SettingsHandler initialized", _classId, LogLevel.finest);
  }

  /// Throws if SharedPreferences is not initialized.
  void _ensurePrefsInitialized() {
    if (_prefs == null) {
      Logger.logError(
        "SettingsHandler not initialized. Call init() before using settings.",
        _classId,
        Exception("SharedPreferences is null"),
      );
      throw StateError(
        "SettingsHandler not initialized. Call init() before using settings.",
      );
    }
  }

  /// Returns the currently selected repository as a [RepositoryDetails] object, or null if not set.
  Future<RepositoryDetails?> getSelectedRepository() async {
    _ensurePrefsInitialized();
    Logger.log("Getting selected repository", _classId, LogLevel.finest);
    final String? jsonString = _prefs?.getString(
      SettingKey.selectedRepository.name,
    );
    if (jsonString == null || jsonString.isEmpty) {
      Logger.log("No selected repository found", _classId, LogLevel.finest);
      return null;
    }
    try {
      final repo = RepositoryDetails.fromJson(
        Map<String, dynamic>.from(jsonDecode(jsonString)),
      );
      Logger.log(
        "Loaded selected repository: ${repo.name}",
        _classId,
        LogLevel.finest,
      );
      return repo;
    } on Exception catch (e) {
      Logger.logError("Failed to decode selected repository", _classId, e);
      return null;
    }
  }

  /// Persists the selected repository [repo].
  Future<void> setSelectedRepository(final RepositoryDetails repo) async {
    _ensurePrefsInitialized();
    Logger.log(
      "Saving selected repository: ${repo.name}",
      _classId,
      LogLevel.finest,
    );
    try {
      await _prefs?.setString(
        SettingKey.selectedRepository.name,
        jsonEncode(repo.toJson()),
      );
      notifyListeners();
      Logger.log("Selected repository saved", _classId, LogLevel.finest);
    } on Exception catch (e) {
      Logger.logError("Failed to save selected repository", _classId, e);
    }
  }

  /// Removes the [key] setting from persistent storage.
  Future<void> remove(final SettingKey key) async {
    _ensurePrefsInitialized();
    try {
      await _prefs?.remove(key.name);
      notifyListeners();
      Logger.log("Setting removed: ${key.name}", _classId, LogLevel.finest);
    } on Exception catch (e) {
      Logger.logError("Failed to remove setting: ${key.name}", _classId, e);
    }
  }

  /// Clears all settings from persistent storage.
  Future<void> clear() async {
    _ensurePrefsInitialized();
    try {
      await _prefs?.clear();
      notifyListeners();
      Logger.log("All settings cleared", _classId, LogLevel.finest);
    } on Exception catch (e) {
      Logger.logError("Failed to clear settings", _classId, e);
    }
  }

  /// Exports all settings as a JSON string.
  Future<String> exportSettings() async {
    _ensurePrefsInitialized();
    try {
      final Set<String> allKeys = _prefs!.getKeys();
      final Map<String, dynamic> settingsMap = {};
      for (final key in allKeys) {
        final Object? value = _prefs!.get(key);
        settingsMap[key] = value;
      }
      final String jsonString = jsonEncode(settingsMap);
      Logger.log("Exported settings as JSON", _classId, LogLevel.finest);
      return jsonString;
    } on Exception catch (e) {
      Logger.logError("Failed to export settings as JSON", _classId, e);
      rethrow;
    }
  }

  /// Imports settings from a JSON string
  Future<void> importSettings(final String json) async {
    _ensurePrefsInitialized();
    try {
      final Map<String, dynamic> importSettings = jsonDecode(json);
      final Set<String> validKeys = SettingKey.values
          .map((final e) => e.name)
          .toSet();
      for (final MapEntry<String, dynamic> entry in importSettings.entries) {
        if (!validKeys.contains(entry.key)) {
          throw Exception("Invalid setting key: ${entry.key}");
        }
      }
      for (final MapEntry<String, dynamic> entry in importSettings.entries) {
        final dynamic value = entry.value;
        if (value is bool) {
          await _prefs!.setBool(entry.key, value);
        } else if (value is int) {
          await _prefs!.setInt(entry.key, value);
        } else if (value is double) {
          await _prefs!.setDouble(entry.key, value);
        } else if (value is String) {
          await _prefs!.setString(entry.key, value);
        } else if (value is List) {
          if (value.every((final element) => element is String)) {
            await _prefs!.setStringList(entry.key, List<String>.from(value));
          }
        }
      }
      notifyListeners();
      Logger.log("Imported settings from JSON", _classId, LogLevel.finest);
    } on Exception catch (e) {
      Logger.logError("Failed to import settings from JSON", _classId, e);
      rethrow;
    }
  }
}
