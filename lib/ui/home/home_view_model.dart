import "dart:convert";

import "package:flutter/material.dart";
import "package:gitdone/core/models/github_model.dart";
import "package:gitdone/core/models/repository_details.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";
import "package:shared_preferences/shared_preferences.dart";

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    loadTodos();
  }
  final List<Todo> _todos = [];
  final List<IssueLabel> _allLabels = [];
  List<Todo> get todos => List.unmodifiable(_todos);
  List<IssueLabel> get allLabels => List.unmodifiable(_allLabels);

  static String classId = "com.GitDone.gitdone.ui.home.home_view_model";

  Future<void> loadTodos() async {
    Logger.logInfo("Loading todos", classId);
    await _loadTodos();
  }

  Future<void> addTodo(final Todo todo) async {
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> removeTodo(final Todo todo) async {
    if (_todos.remove(todo)) {
      notifyListeners();
    }
  }

  Future<void> _loadTodos() async {
    try {
      _todos.clear();
      final RepositoryDetails? repo = await _getSelectedRepository();
      if (repo != null) {
        final List<Todo> issues = await _fetchIssuesForRepository(repo);
        _todos.addAll(issues);
        final List<IssueLabel> labels = await _fetchAllLabels(repo);
        _allLabels.addAll(labels);
      }
    } catch (e) {
      Logger.logError("Failed to load todos", classId, e);
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

  Future<List<Todo>> _fetchIssuesForRepository(
    final RepositoryDetails repo,
  ) async => (await GithubModel.github).issues
      .listByRepo(repo.toSlug())
      .where((final issue) => issue.pullRequest == null)
      .map(Todo.fromIssue)
      .toList();

  Future<List<IssueLabel>> _fetchAllLabels(
    final RepositoryDetails repo,
  ) async =>
      (await GithubModel.github).issues.listLabels(repo.toSlug()).toList();
}
