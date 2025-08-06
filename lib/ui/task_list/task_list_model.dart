import "package:flutter/material.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";

/// ViewModel for the Home View.
class TaskListModel extends ChangeNotifier {
  /// Creates a new instance of [TaskListModel] and loads the tasks.
  TaskListModel() {
    _taskHandler
      ..addListener(_listener)
      ..loadTasks()
      ..loadLabels();
  }
  final TaskHandler _taskHandler = TaskHandler();

  final List<Task> _task = [];
  final List<IssueLabel> _allLabels = [];

  /// The list of tasks loaded from the repository.
  List<Task> get tasks => List.unmodifiable(_task);

  /// The list of all labels available in the repository.
  List<IssueLabel> get allLabels => List.unmodifiable(_allLabels);

  static const _classId = "com.GitDone.gitdone.ui.task_list.task_list_model";

  void _listener() {
    Logger.logInfo(
      "Recieved notification from task_handler. Loading tasks",
      _classId,
    );
    _task
      ..clear()
      ..addAll(_taskHandler.tasks);

    _allLabels
      ..clear()
      ..addAll(_taskHandler.allLabels);

    notifyListeners();
  }

  @override
  void dispose() {
    Logger.logInfo("Disposing TaskListModel", _classId);
    _taskHandler.removeListener(_listener);
    super.dispose();
  }

  /// Loads the tasks from the repository.
  Future<void> loadTasks() async {
    Logger.logInfo("Loading tasks", _classId);
    await loadTasks();
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
}
