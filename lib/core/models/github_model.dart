import "package:gitdone/core/models/token_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";

/// This model handles the GitHub API interactions.
class GithubModel {
  /// Factory constructor to ensure a singleton instance.
  factory GithubModel() => _instance;

  GithubModel._internal();

  /// Factory constructor to ensure a singleton instance.
  static final GithubModel _instance = GithubModel._internal();

  static const _classId = "com.GitDone.gitdone.core.models.github_model";

  static GitHub? _github;

  static Future<void> _init() async {
    Logger.log("Initializing GitHub", _classId, LogLevel.finest);
    final String? token = await TokenHandler().getToken();
    _github = GitHub(auth: Authentication.bearerToken(token!));
  }

  /// Gets the GitHub instance.
  /// If it is not initialized, it will be initialized first.
  static Future<GitHub> get github async {
    if (_github == null) {
      await GithubModel._init();
    }
    return _github!;
  }
}
