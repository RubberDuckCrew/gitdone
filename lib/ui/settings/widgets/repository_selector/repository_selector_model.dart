import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gitdone/core/models/repository_details.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/core/utils/logger.dart';
import 'package:github_flutter/github.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositorySelectorModel extends ChangeNotifier {
  String classId =
      "com.GitDone.gitdone.ui.settings.widgets.repository_selector.repository_selector_model";

  GitHub? _github;

  final List<RepositoryDetails> _repositories = [];
  List<RepositoryDetails> get repositories => _repositories;

  RepositoryDetails? _selectedRepository;
  RepositoryDetails? get selectedRepository => _selectedRepository;

  bool get locallySavedRepoExist => _selectedRepository != null ? true : false;

  Future<void> loadLocalRepository() async {
    Logger.log("Loading local repository", classId, LogLevel.finest);
    final prefs = await SharedPreferences.getInstance();
    String repoJson = prefs.getString('selected_repository') ?? "";
    if (repoJson.isNotEmpty) {
      RepositoryDetails repo = RepositoryDetails.fromJson(
        Map<String, dynamic>.from(jsonDecode(repoJson)),
      );
      Logger.log("Found local repository: $repoJson", classId, LogLevel.finest);
      _repositories.add(repo);
      _selectedRepository = repo;
      notifyListeners();
    }
  }

  Future<bool> init() async {
    Logger.log("Calling init method", classId, LogLevel.finest);

    if (_github == null) {
      String? token = await TokenHandler().getToken();
      _github = GitHub(auth: Authentication.bearerToken(token!));
      Logger.log("Initialized GitHub", classId, LogLevel.finest);
      return true;
    }
    return false;
  }

  void getAllUserRepositories() async {
    await loadLocalRepository();
    if (_github == null) {
      Logger.log(
        "Called getAllUserRepositories() while GitHub is null. Initializing...",
        classId,
        LogLevel.finest,
      );
      await init();
    }
    Logger.log("Fetching repositories", classId, LogLevel.finest);
    _repositories.addAll(
      await _github!.repositories
          .listRepositories(type: "all")
          .where((repo) => repo.name != _selectedRepository?.name)
          .map(RepositoryDetails.fromRepository)
          .toList(),
    );

    notifyListeners();
  }

  void clearRepositories() {
    Logger.log("Clearing repositories", classId, LogLevel.finest);
    _repositories.clear();
    notifyListeners();
  }

  void saveRepository(RepositoryDetails repository) async {
    Logger.log(
      "Saving repository: ${repository.name} to shared preferences",
      classId,
      LogLevel.finest,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'selected_repository',
      jsonEncode(repository.toJson()),
    );
  }

  void selectRepository(RepositoryDetails? repo) {
    Logger.log("Selected repository: ${repo?.name}", classId, LogLevel.finest);
    _selectedRepository = repo;
    notifyListeners();
  }
}
