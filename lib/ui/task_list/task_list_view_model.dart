import "package:flutter/material.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/ui/task_list/task_list_model.dart";
import "package:github_flutter/github.dart";

/// ViewModel for the Home View.
class TaskListViewModel extends ChangeNotifier {
  /// Creates a new instance of [TaskListViewModel] and initializes the filters.
  TaskListViewModel() {
    _homeViewModel.addListener(() {
      _applyFilters();
      notifyListeners();
    });
    _filteredTasks = _homeViewModel.tasks;
    _filterLabels.addAll(_homeViewModel.allLabels);
  }

  static const String _classId =
      "com.GitDone.gitdone.ui/task_list/task_list_view_model";

  final TaskListModel _homeViewModel = TaskListModel();
  final List<IssueLabel> _filterLabels = [];
  List<Task> _filteredTasks = [];
  String _searchQuery = "";
  String _filter = "";
  String _sort = "";
  bool _isEmpty = false;

  /// The list of filtered tasks based on the current search query, filter, and sort.
  List<Task> get tasks => _filteredTasks;

  /// The list of labels currently being filtered.
  List<IssueLabel> get allLabels => _homeViewModel.allLabels;

  /// The list of labels used for filtering tasks.
  bool get isEmpty => _isEmpty;

  /// The list of labels currently being used for filtering.
  void updateLabels(final String label, {final bool selected = false}) {
    if (label.isEmpty) _filterLabels.clear();

    if (selected) {
      _filterLabels.addAll(
        _homeViewModel.allLabels.where((final l) => l.name == label),
      );
    } else {
      _filterLabels.removeWhere((final l) => l.name == label);
    }

    Logger.log("Selected labels: $_filterLabels", _classId, LogLevel.finest);

    notifyListeners();
    _applyFilters();
  }

  /// The current search query used to filter tasks.
  Future<void> loadTasks() async {
    await _homeViewModel.loadTasks();
    _isEmpty = _homeViewModel.tasks.isEmpty;
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

  void _applyFilters() {
    _filteredTasks = _homeViewModel.tasks;

    if (_searchQuery.isNotEmpty) {
      _filteredTasks = _filteredTasks.where((final task) {
        final String query = _searchQuery.toLowerCase();
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }

    if (_filter == "Completed") {
      _filteredTasks = _filteredTasks
          .where((final task) => task.closedAt != null)
          .toList();
    } else if (_filter == "Pending") {
      _filteredTasks = _filteredTasks
          .where((final task) => task.closedAt == null)
          .toList();
    }

    /// FIXME: This is a workaround to ensure that the list is not immutable
    _filteredTasks = List.of(_filteredTasks);

    if (_sort == "Alphabetical") {
      _filteredTasks.sort((final a, final b) => a.title.compareTo(b.title));
    } else if (_sort == "Last updated") {
      _filteredTasks.sort(
        (final a, final b) =>
            (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt),
      );
    } else if (_sort == "Created") {
      _filteredTasks.sort(
        (final a, final b) => b.createdAt.compareTo(a.createdAt),
      );
    }

    if (_filterLabels.isNotEmpty) {
      _filteredTasks = _filteredTasks
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

    notifyListeners();
  }
}
