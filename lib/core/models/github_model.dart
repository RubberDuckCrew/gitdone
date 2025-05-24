import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/core/utils/logger.dart';
import 'package:github_flutter/github.dart';

class GithubModel {
  static final GithubModel _instance = GithubModel._internal();

  GithubModel._internal();

  factory GithubModel() => _instance;

  static String classId = "com.GitDone.gitdone.core.models.github_model";

  static GitHub? _github;

  static Future<void> _init() async {
    Logger.log("Initializing GitHub", classId, LogLevel.finest);
    String? token = await TokenHandler().getToken();
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
