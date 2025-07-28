import "dart:convert";

import "package:flutter/material.dart";
import "package:gitdone/core/models/github_model.dart";
import "package:gitdone/core/models/repository_details.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";
import "package:shared_preferences/shared_preferences.dart";

/// ViewModel for the Home View.
class TaskListModel extends ChangeNotifier {
  /// Creates a new instance of [TaskListModel] and loads the tasks.
  TaskListModel() {
    loadTasks();
  }

  final List<Task> _task = [];
  final List<IssueLabel> _allLabels = [];

  /// The list of tasks loaded from the repository.
  List<Task> get tasks => List.unmodifiable(_task);

  /// The list of all labels available in the repository.
  List<IssueLabel> get allLabels => List.unmodifiable(_allLabels);

  /// The class identifier for logging purposes.
  static String classId = "com.GitDone.gitdone.ui.task_list.task_list_model";

  /// Loads the tasks from the repository.
  Future<void> loadTasks() async {
    Logger.logInfo("Loading tasks", classId);
    await _loadTasks();
  }

  /// Adds a new task to the list.
  Future<void> addTask(final Task task) async {
    _task.add(task);
    notifyListeners();
  }

  /// Removes a task from the list.
  Future<void> removeTask(final Task task) async {
    if (_task.remove(task)) {
      notifyListeners();
    }
  }

  Future<void> _loadTasks() async {
    try {
      _task.clear();
      final RepositoryDetails? repo = await _getSelectedRepository();
      if (repo != null) {
        final List<Task> issues = await _fetchIssuesForRepository(repo);
        _task
          ..clear()
          ..addAll(issues);
        final List<IssueLabel> labels = await _fetchAllLabels(repo);
        _allLabels
          ..clear()
          ..addAll(labels);
      }
    } on Exception catch (e) {
      Logger.logError("Failed to load tasks", classId, e);
    } finally {
      notifyListeners();
    }
  }

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

  Future<List<Task>> _fetchIssuesForRepository(
    final RepositoryDetails repo,
  ) async => (await GithubModel.github).issues
      .listByRepo(repo.toSlug(), state: "all")
      .where((final issue) => issue.pullRequest == null)
      .map((final issue) => Task.fromIssue(issue, repo.toSlug()))
      .toList();

  Future<List<IssueLabel>> _fetchAllLabels(
    final RepositoryDetails repo,
  ) async =>
      (await GithubModel.github).issues.listLabels(repo.toSlug()).toList();
}
