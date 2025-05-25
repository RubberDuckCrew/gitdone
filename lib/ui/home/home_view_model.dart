import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gitdone/core/models/github_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/repository_details.dart';
import '../../core/models/todo.dart';
import '../../core/utils/logger.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Todo> _todos = [];
  List<Todo> get todos => List.unmodifiable(_todos);

  HomeViewModel() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    Logger.logInfo("Loading todos", "HomeViewModel");
    await _loadTodos();
  }

  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> removeTodo(Todo todo) async {
    if (_todos.remove(todo)) {
      notifyListeners();
    }
  }

  Future<void> _loadTodos() async {
    try {
      _todos.clear();
      final repo = await _getSelectedRepository();
      if (repo != null) {
        final issues = await _fetchIssuesForRepository(repo);
        _todos.addAll(issues);
      }
    } catch (e) {
      Logger.logError("Failed to load todos", "HomeViewModel", e);
    } finally {
      notifyListeners();
    }
  }

  Future<RepositoryDetails?> _getSelectedRepository() async {
    final prefs = await SharedPreferences.getInstance();
    final repoJson = prefs.getString('selected_repository') ?? "";
    if (repoJson.isNotEmpty) {
      return RepositoryDetails.fromJson(
        Map<String, dynamic>.from(jsonDecode(repoJson)),
      );
    }
    return null;
  }

  Future<List<Todo>> _fetchIssuesForRepository(RepositoryDetails repo) async {
    return (await GithubModel.github).issues
        .listByRepo(repo.toSlug())
        .where((issue) => issue.pullRequest == null)
        .map(Todo.fromIssue)
        .toList();
  }
}
