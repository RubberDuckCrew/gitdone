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
}
