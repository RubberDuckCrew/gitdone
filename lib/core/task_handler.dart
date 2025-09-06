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

  List<Task> _tasks = [];

  List<IssueLabel> _repoLabels = [];

  /// The list of all tasks available in the repository.
  List<Task> get tasks => List.unmodifiable(_tasks);

  /// The list of all labels available in the repository.
  List<IssueLabel> get repoLabels => List.unmodifiable(_repoLabels);

  /// The list of all tasks available in the repository.
  /// After the notification the current list of task is stored in [tasks].
  Future<void> loadTasks() async {
    try {
      final RepositoryDetails? repo = await _getSelectedRepository();
      if (repo == null) {
        Logger.logWarning("No repository selected", _classId);
        return;
      }
      final List<Task> issues = await _fetchIssuesForRepository(repo);
      Logger.logInfo(
        "Adding ${issues.length} tasks to the repository",
        _classId,
      );
      _tasks = issues;
      Logger.logInfo(
        "Currently ${_tasks.length} tasks in the repository",
        _classId,
      );
    } on Exception catch (e) {
      Logger.logError("Failed to load tasks", _classId, e);
    } finally {
      Logger.logInfo("Loaded ${_tasks.length} tasks from repository", _classId);
      notifyListeners();
    }
  }

  /// The list of all labels available in the repository.
  /// After the notification the current list of labels is stored in [repoLabels].
  Future<void> loadLabels() async {
    try {
      _repoLabels.clear();
      final RepositoryDetails? repo = await _getSelectedRepository();
      if (repo == null) {
        Logger.logWarning("No repository selected", _classId);
        return;
      }
      _repoLabels = await (await GithubModel.github).issues
          .listLabels(repo.toSlug())
          .toList();
      Logger.logInfo(
        "Loaded ${_repoLabels.length} labels from repository ${repo.toSlug()}",
        _classId,
      );
      notifyListeners();
    } on Exception catch (e) {
      Logger.logError("Failed to load labels", _classId, e);
    }
  }

  /// Creates a new task or updates an existing task and adds it to the list of tasks. Notifies listeners
  /// about the change.
  /// Returns the created task if successful, otherwise returns the original task.
  Future<Task> saveTask(final Task task) async {
    try {
      final Task createdTask = await task.saveRemote();

      // Add the created task to the local list of tasks if it does not already exist
      // This prevents duplicates in the local task list.
      if (!_tasks.any((final t) => t.issueNumber == createdTask.issueNumber)) {
        _tasks.add(createdTask);
      }

      notifyListeners();
      return createdTask;
    } on Exception catch (e) {
      Logger.logError("Failed to create task", _classId, e);
    }
    return task;
  }

  /// Updates an existing task in the list of tasks. Notifies listeners about the change.
  /// Does not save the task to the remote repository!
  void updateLocalTask(final Task task) {
    final int index = _tasks.indexWhere(
      (final t) => t.issueNumber == task.issueNumber,
    );
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    } else {
      Logger.logWarning(
        "Task with id ${task.issueNumber} not found in local tasks",
        _classId,
      );
    }
  }

  /// Deletes a task from the list of tasks. Notifies listeners about the change.
  /// Also deletes the task from the remote repository.
  /// If the task does not exist in the remote repository, it will be removed from the local list.
  Future<void> deleteTask(final Task task) async {
    try {
      await task.deleteRemote();
      _tasks.removeWhere((final t) => t.issueNumber == task.issueNumber);
      notifyListeners();
    } on Exception catch (e) {
      Logger.logError("Failed to delete task", _classId, e);
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

  /// Marks a task as done by updating its state to "closed" and setting the closedAt timestamp.
  Future<Task> updateIssueState(
    final Task task,
    final IssueState newState,
  ) async {
    Logger.log(
      "Marking task as ${newState.value}: ${task.title}",
      _classId,
      LogLevel.detailed,
    );

    task
      ..state = newState.value
      ..closedAt = newState == IssueState.closed
          ? DateTime.now().toUtc()
          : task.closedAt
      ..updatedAt = DateTime.now().toUtc()
      ..saveRemote();

    final int index = _tasks.indexWhere(
      (final t) => t.issueNumber == task.issueNumber,
    );
    if (index != -1) {
      _tasks[index] = task;
    } else {
      Logger.logWarning(
        "Task with id ${task.issueNumber} not found in local tasks",
        _classId,
      );
    }

    notifyListeners();

    return task;
  }
}

/// Enum representing the state of an issue in a repository.
enum IssueState {
  /// The issue is open and active.
  open("open"),

  /// The issue is closed and inactive.
  closed("closed");

  const IssueState(this._value);
  final String _value;

  /// Returns the string representation of the issue state.
  String get value => _value;

  /// Returns the IssueState corresponding to the given string value.
  static IssueState fromValue(final String value) {
    for (final IssueState state in IssueState.values) {
      if (state.value == value) {
        return state;
      }
    }
    throw ArgumentError("Illegal value: $value");
  }
}
