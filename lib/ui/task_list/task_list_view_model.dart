import "package:flutter/material.dart";
import "package:gitdone/core/models/task.dart";
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
  void updateLabels(final String label) {
    _filterLabels
      ..clear()
      ..addAll(
        label.isEmpty
            ? _homeViewModel.allLabels
            : _homeViewModel.allLabels.where((final l) => l.name == label),
      );
    notifyListeners();
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

  /// The current filter applied to the tasks.
  void updateFilter(final String filter) {
    _filter = filter;
    _applyFilters();
  }

  /// The current sort order applied to the tasks.
  void updateSort(final String sort) {
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
          .where((final task) => task.labels.any(_filterLabels.contains))
          .toList();
    }

    notifyListeners();
  }
}
