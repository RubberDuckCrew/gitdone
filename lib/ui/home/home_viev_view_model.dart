import 'package:flutter/material.dart';

import '../../core/models/todo.dart';
import 'home_view_model.dart';

class HomeViewViewModel extends ChangeNotifier {
  final HomeViewModel _homeViewModel = HomeViewModel();
  List<Todo> _filteredTodos = [];
  String _searchQuery = '';
  String _filter = '';
  String _sort = '';

  List<Todo> get todos => _filteredTodos;

  HomeViewViewModel() {
    _homeViewModel.addListener(() {
      _applyFilters();
      notifyListeners();
    });
    _filteredTodos = _homeViewModel.todos;
  }

  void loadTodos() {
    _homeViewModel.loadTodos();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void updateFilter(String filter) {
    _filter = filter;
    _applyFilters();
  }

  void updateSort(String sort) {
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
                (todo) =>
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
    if (_filter == 'Completed') {
      _filteredTodos =
          _filteredTodos.where((todo) => todo.closedAt != null).toList();
    } else if (_filter == 'Pending') {
      _filteredTodos =
          _filteredTodos.where((todo) => todo.closedAt == null).toList();
    }
    // Sort
    if (_sort == 'Alphabetical') {
      _filteredTodos.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sort == 'Last updated') {
      // Sort by updatedAt, if null then use createdAt
      _filteredTodos.sort(
        (a, b) =>
            (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt),
      );
    } else if (_sort == 'Created') {
      _filteredTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    notifyListeners();
  }
}
