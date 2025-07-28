import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/ui/todo_list/todo_list_model.dart";
import "package:github_flutter/github.dart";
import "package:gitdone/core/utils/logger.dart";

/// ViewModel for the Home View.
class TodoListViewModel extends ChangeNotifier {
  /// Creates a new instance of [TodoListViewModel] and initializes the filters.
  TodoListViewModel() {
    _homeViewModel.addListener(() {
      _applyFilters();
      notifyListeners();
    });
    _filteredTodos = _homeViewModel.todos;
    _filterLabels.addAll(_homeViewModel.allLabels);
  }

  static const String _classId =
      "com.GitDone.gitdone.ui/todo_list.todo_list_view_model";

  final TodoListModel _homeViewModel = TodoListModel();
  final List<IssueLabel> _filterLabels = [];
  List<Todo> _filteredTodos = [];
  String _searchQuery = "";
  String _filter = "";
  String _sort = "";
  bool _isEmpty = false;

  /// The list of filtered todos based on the current search query, filter, and sort.
  List<Todo> get todos => _filteredTodos;

  /// The list of labels currently being filtered.
  List<IssueLabel> get allLabels => _homeViewModel.allLabels;

  /// The list of labels used for filtering todos.
  bool get isEmpty => _isEmpty;

  /// The list of labels currently being used for filtering.
  void updateLabels(final String label, final bool selected) {
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

  /// The current search query used to filter todos.
  Future<void> loadTodos() async {
    await _homeViewModel.loadTodos();
    _isEmpty = _homeViewModel.todos.isEmpty;
    notifyListeners();
  }

  /// The current search query used to filter todos.
  void updateSearchQuery(final String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// The current filter applied to the todos.
  void updateFilter(final String filter, final bool _) {
    Logger.log("Updating filter to: $filter", _classId, LogLevel.finest);
    _filter = filter;
    _applyFilters();
  }

  /// The current sort order applied to the todos.
  void updateSort(final String sort, final bool _) {
    _sort = sort;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredTodos = _homeViewModel.todos;

    if (_searchQuery.isNotEmpty) {
      _filteredTodos = _filteredTodos.where((final todo) {
        final String query = _searchQuery.toLowerCase();
        return todo.title.toLowerCase().contains(query) ||
            todo.description.toLowerCase().contains(query);
      }).toList();
    }

    final int listLength = _filteredTodos.length;
    Logger.log(
      "Filtering $listLength todos: $_filteredTodos",
      _classId,
      LogLevel.finest,
    );

    if (_filter == "Completed") {
      _filteredTodos = _filteredTodos
          .where((final todo) => todo.closedAt != null)
          .toList();
    } else if (_filter == "Pending") {
      _filteredTodos = _filteredTodos
          .where((final todo) => todo.closedAt == null)
          .toList();
    }

    /// FIXME: This is a workaround to ensure that the list is not immutable
    _filteredTodos = List.of(_filteredTodos);

    if (_sort == "Alphabetical") {
      _filteredTodos.sort((final a, final b) => a.title.compareTo(b.title));
    } else if (_sort == "Last updated") {
      _filteredTodos.sort(
        (final a, final b) =>
            (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt),
      );
    } else if (_sort == "Created") {
      _filteredTodos.sort(
        (final a, final b) => b.createdAt.compareTo(a.createdAt),
      );
    }

    if (_filterLabels.isNotEmpty) {
      _filteredTodos = _filteredTodos
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
