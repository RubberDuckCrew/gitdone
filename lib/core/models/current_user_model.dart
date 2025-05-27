import 'package:gitdone/core/models/github_model.dart';
import 'package:gitdone/core/utils/logger.dart';
import 'package:github_flutter/github.dart';

/// This model handles the current user information from GitHub.
class CurrentUserModel {
  /// Factory constructor to ensure a singleton instance.
  factory CurrentUserModel() => _instance;

  CurrentUserModel._internal();

  /// Factory constructor to ensure a singleton instance.
  static final CurrentUserModel _instance = CurrentUserModel._internal();

  /// The class identifier for logging purposes.
  static String classId = "com.GitDone.gitdone.core.models.current_user_model";

  static CurrentUser? _currentUser;

  static Future<void> _fetchCurrentUser() async {
    Logger.log("Fetching currentUser from GitHub", classId, LogLevel.finest);
    _currentUser = await (await GithubModel.github).users.getCurrentUser();
  }

  /// Gets the current user from GitHub.
  static Future<User> get currentUser async {
    if (_currentUser == null) {
      await _fetchCurrentUser();
    }
    return _currentUser ?? User();
  }
}
