import "dart:convert";

import "package:flutter/material.dart";
import "package:gitdone/core/models/repository_details.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/task_details/task_details_view.dart";
import "package:gitdone/ui/task_edit/task_edit_view.dart";
import "package:github_flutter/github.dart";
import "package:shared_preferences/shared_preferences.dart";

/// ViewModel for the Home View.
class TaskListViewModel extends ChangeNotifier {
  /// Creates a new instance of [TaskListViewModel] and initializes the filters.
  TaskListViewModel() {
    _taskHandler
      ..addListener(_listener)
      ..loadTasks()
      ..loadLabels();
    print("TaskListViewModel initialized");
    print("Label count: ${_taskHandler.repoLabels.length}");
    print(
      "Labels: ${_taskHandler.repoLabels.map((final label) => label.name).join(", ")}",
    );
  }

  final TaskHandler _taskHandler = TaskHandler();
  final List<IssueLabel> _filterLabels = [];
  List<Task> _filteredTasks = [];
  String _searchQuery = "";
  String _filter = "";
  String _sort = "";
  bool _isEmpty = false;

  static const _classId =
      "com.GitDone.gitdone.ui.task_edit.task_list_view_model";

  /// The list of filtered tasks based on the current search query, filter, and sort.
  List<Task> get tasks => _filteredTasks;

  /// The list of labels currently being filtered.
  List<IssueLabel> get allLabels => _taskHandler.repoLabels;

  /// The list of labels used for filtering tasks.
  bool get isEmpty => _isEmpty;

  /// The list of labels currently being used for filtering.
  void updateLabels(final String label, {final bool selected = false}) {
    if (label.isEmpty) _filterLabels.clear();

    if (selected) {
      _filterLabels.addAll(
        _taskHandler.repoLabels.where((final l) => l.name == label),
      );
    } else {
      _filterLabels.removeWhere((final l) => l.name == label);
    }

    Logger.log("Selected labels: $_filterLabels", _classId, LogLevel.finest);

    notifyListeners();
    _applyFilters();
  }

  void _listener() {
    Logger.logInfo(
      "Received notification from task_handler. Tunneling notification to TaskListView",
      _classId,
    );
    _filteredTasks = _taskHandler.tasks;
    _applyFilters();

    notifyListeners();
  }

  @override
  void dispose() {
    Logger.logInfo("Disposing TaskListViewModel", _classId);
    _taskHandler.removeListener(_listener);
    super.dispose();
  }

  /// The current search query used to filter tasks.
  Future<void> loadTasks() async {
    await _taskHandler.loadTasks();
    _isEmpty = _taskHandler.tasks.isEmpty;
    notifyListeners();
  }

  /// The current search query used to filter tasks.
  void updateSearchQuery(final String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// The current filter applied to the task.
  void updateFilter(final String filter, {final bool selected = false}) {
    _filter = filter;
    _applyFilters();
  }

  /// The current sort order applied to the task.
  void updateSort(final String sort, {final bool selected = false}) {
    _sort = sort;
    _applyFilters();
  }

  List<Task> _applyCompletedFilter(
    final List<Task> tasks,
    final String filter,
  ) {
    if (filter == "Completed") {
      return tasks.where((final task) => task.closedAt != null).toList();
    } else if (filter == "Pending") {
      return tasks.where((final task) => task.closedAt == null).toList();
    }
    return tasks;
  }

  List<Task> _applySearchQuery(final List<Task> tasks, final String query) {
    if (query.isEmpty) return tasks;

    return tasks.where((final task) {
      final String query = _searchQuery.toLowerCase();
      return task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);
    }).toList();
  }

  List<Task> _applyLabelFilter(
    final List<Task> tasks,
    final List<IssueLabel> labels,
  ) {
    if (labels.isEmpty) return tasks;

    return tasks
        .where(
          (final todo) => todo.labels
              .map((final label) => label.name)
              .any(
                (final labelName) => _filterLabels
                    .map((final filterLabel) => filterLabel.name)
                    .contains(labelName),
              ),
        )
        .toList();
  }

  /// Sanitizes a string by removing all non-alphanumeric characters.
  /// This is used to ensure consistent alphabetic sorting of task titles.
  String _sanitizeString(final String input) =>
      input.replaceAll(RegExp("[^a-zA-Z0-9]"), "");

  List<Task> _sortTasks(final List<Task> tasks, final String sort) =>
      switch (sort) {
        "Alphabetical" =>
          tasks..sort(
            (final a, final b) =>
                _sanitizeString(a.title).compareTo(_sanitizeString(b.title)),
          ),
        "Last updated" =>
          tasks..sort((final a, final b) => b.updatedAt.compareTo(a.updatedAt)),
        "Created" =>
          tasks..sort((final a, final b) => b.createdAt.compareTo(a.createdAt)),
        _ => tasks,
      };

  void _applyFilters() {
    _filteredTasks = _taskHandler.tasks;
    _filteredTasks = _applyCompletedFilter(_filteredTasks, _filter);
    _filteredTasks = _applySearchQuery(_filteredTasks, _searchQuery);
    _filteredTasks = _applyLabelFilter(_filteredTasks, _filterLabels);

    /// FIXME: This is a workaround to ensure that the list is not immutable
    _filteredTasks = List.of(_filteredTasks);
    _filteredTasks = _sortTasks(_filteredTasks, _sort);

    notifyListeners();
  }

  /// Creates a new to do and navigates to the TaskDetailsView.
  Future<void> createTask() async {
    Logger.log("Creating task", _classId, LogLevel.detailed);
    final RepositoryDetails? repo = await _getSelectedRepository();
    if (repo == null) {
      Logger.log("No repository selected", _classId, LogLevel.info);
      return;
    }
    final Task? newTask = await Navigation.navigate(
      TaskEditView(Task.createEmpty(repo.toSlug())),
    );
    if (newTask == null) {
      Logger.log(
        "Task creation cancelled or failed",
        _classId,
        LogLevel.detailed,
      );
      return;
    }
    Logger.log("Task created: $newTask", _classId, LogLevel.detailed);
    Navigation.navigate(TaskDetailsView(newTask));
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
}
