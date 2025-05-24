import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_flutter/github.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/repository_details.dart';
import '../../core/models/todo.dart';
import '../../core/models/token_handler.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Todo> _todos = [];

  GitHub? _github;

  List<Todo> get todos => _todos;

  HomeViewModel() {
    init().then((_) {
      getTodos();
    });
  }

  Future<void> init() async {
    if (_github == null) {
      String? token = await TokenHandler().getToken();
      _github = GitHub(auth: Authentication.bearerToken(token!));
    }
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void removeTodo(Todo todo) {
    if (_todos.contains(todo)) {
      _todos.remove(todo);
      notifyListeners();
    }
  }

  void getTodos() async {
    _todos.clear();
    final prefs = await SharedPreferences.getInstance();
    String repoJson = prefs.getString('selected_repository') ?? "";
    if (repoJson.isNotEmpty) {
      RepositoryDetails repo = RepositoryDetails.fromJson(
        Map<String, dynamic>.from(jsonDecode(repoJson)),
      );
      _todos.addAll(
        await _github!.issues
            .listByRepo(repo.toSlug())
            .where((issue) => issue.pullRequest == null)
            .map(Todo.fromIssue)
            .toList(),
      );
      notifyListeners();
    }
  }
}
