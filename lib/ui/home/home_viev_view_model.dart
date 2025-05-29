import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/ui/home/home_view_model.dart";
import "package:github_flutter/github.dart";

/// ViewModel for the Home View.
class HomeViewViewModel extends ChangeNotifier {
  /// Class identifier for logging purposes.
  HomeViewViewModel() {
    _homeViewModel.addListener(() {
      _applyFilters();
      notifyListeners();
    });
    _filteredTodos = _homeViewModel.todos;
    _filterLabels.addAll(_homeViewModel.allLabels);
  }
  final HomeViewModel _homeViewModel = HomeViewModel();
  final List<IssueLabel> _filterLabels = [];
  List<Todo> _filteredTodos = [];
  String _searchQuery = "";
  String _filter = "";
  String _sort = "";

  /// The list of filtered todos based on search, filter, and sort criteria.
  List<Todo> get todos => _filteredTodos;

  /// All labels available in the repository.
  List<IssueLabel> get allLabels => _homeViewModel.allLabels;

  /// Updates the labels used for filtering todos.
  void updateLabels(final String label) {
    _filterLabels.clear();
    if (label.isEmpty) {
      _filterLabels.addAll(_homeViewModel.allLabels);
    } else {
      _filterLabels.addAll(
        _homeViewModel.allLabels.where((final l) => l.name == label),
      );
    }
    notifyListeners();
  }

  /// Loads the todos from the repository.
  void loadTodos() {
    _homeViewModel.loadTodos();
  }

  /// Updates the search query and applies filters.
  void updateSearchQuery(final String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Updates the filter criteria and applies filters.
  void updateFilter(final String filter) {
    _filter = filter;
    _applyFilters();
  }

  /// Updates the sort criteria and applies filters.
  void updateSort(final String sort) {
    _sort = sort;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredTodos = _homeViewModel.todos;
    // Search
    if (_searchQuery.isNotEmpty) {
      _filteredTodos =
          _filteredTodos
              .where(
                (final todo) =>
                    todo.title.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    todo.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }
    // Filter
    if (_filter == "Completed") {
      _filteredTodos =
          _filteredTodos.where((final todo) => todo.closedAt != null).toList();
    } else if (_filter == "Pending") {
      _filteredTodos =
          _filteredTodos.where((final todo) => todo.closedAt == null).toList();
    }
    // Sort
    if (_sort == "Alphabetical") {
      _filteredTodos.sort((final a, final b) => a.title.compareTo(b.title));
    } else if (_sort == "Last updated") {
      // Sort by updatedAt, if null then use createdAt
      _filteredTodos.sort(
        (final a, final b) =>
            (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt),
      );
    } else if (_sort == "Created") {
      _filteredTodos.sort(
        (final a, final b) => b.createdAt.compareTo(a.createdAt),
      );
    }
    // Labels
    if (_filterLabels.isNotEmpty) {
      _filteredTodos =
          _filteredTodos
              .where((final todo) => todo.labels.any(_filterLabels.contains))
              .toList();
    }
    notifyListeners();
  }
}
