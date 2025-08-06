import "dart:convert";

import "package:flutter/foundation.dart";
import "package:gitdone/core/models/github_model.dart";
import "package:gitdone/core/models/repository_details.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";
import "package:shared_preferences/shared_preferences.dart";

/// A singleton class that manages tasks for the application.
class TaskHandler extends ChangeNotifier {
  /// Creates a new instance of [TaskHandler].
  factory TaskHandler() => _instance;

  TaskHandler._internal();
  static const _classId = "com.GitDone.gitdone.core.task_handler";
  static final TaskHandler _instance = TaskHandler._internal();

  final List<Task> _tasks = [];

  final List<IssueLabel> _labels = [];

  /// The list of all tasks available in the repository.
  List<Task> get tasks => List.unmodifiable(_tasks);

  /// The list of all labels available in the repository.
  List<IssueLabel> get allLabels => List.unmodifiable(_labels);

  /// The list of all tasks available in the repository.
  /// After the notification the current list of task is stored in [tasks].
  Future<void> loadTasks() async {
    try {
      _tasks.clear();
      final RepositoryDetails? repo = await _getSelectedRepository();
      if (repo == null) {
        Logger.logWarning("No repository selected", _classId);
        return;
      }
      final List<Task> issues = await _fetchIssuesForRepository(repo);
      _tasks.addAll(issues);
    } on Exception catch (e) {
      Logger.logError("Failed to load tasks", _classId, e);
    } finally {
      Logger.logInfo("Loaded ${_tasks.length} tasks from repository", _classId);
      notifyListeners();
    }
  }

  /// The list of all labels available in the repository.
  /// After the notification the current list of labels is stored in [allLabels].
  Future<void> loadLabels() async {
    try {
      _labels.clear();
      final RepositoryDetails? repo = await _getSelectedRepository();
      if (repo == null) {
        Logger.logWarning("No repository selected", _classId);
        return;
      }
      _labels.addAll(
        await (await GithubModel.github).issues
            .listLabels(repo.toSlug())
            .toList(),
      );
      notifyListeners();
    } on Exception catch (e) {
      Logger.logError("Failed to load labels", _classId, e);
    }
  }

  Future<List<Task>> _fetchIssuesForRepository(
    final RepositoryDetails repo,
  ) async => (await GithubModel.github).issues
      .listByRepo(repo.toSlug(), state: "all")
      .where((final issue) => issue.pullRequest == null)
      .map((final issue) => Task.fromIssue(issue, repo.toSlug()))
      .toList();

  Future<RepositoryDetails?> _getSelectedRepository() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String repoJson = prefs.getString("selected_repository") ?? "";
    if (repoJson.isNotEmpty) {
      return RepositoryDetails.fromJson(
        Map<String, dynamic>.from(jsonDecode(repoJson)),
      );
    }
    return null;
  }
}
