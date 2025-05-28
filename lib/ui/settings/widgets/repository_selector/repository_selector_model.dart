import "dart:convert";

import "package:flutter/material.dart";
import "package:gitdone/core/models/github_model.dart";
import "package:gitdone/core/models/repository_details.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:shared_preferences/shared_preferences.dart";

class RepositorySelectorModel extends ChangeNotifier {
  String classId =
      "com.GitDone.gitdone.ui.settings.widgets.repository_selector.repository_selector_model";

  final List<RepositoryDetails> _repositories = [];
  List<RepositoryDetails> get repositories => _repositories;

  RepositoryDetails? _selectedRepository;
  RepositoryDetails? get selectedRepository => _selectedRepository;

  bool get locallySavedRepoExist => _selectedRepository != null ? true : false;

  Future<void> loadLocalRepository() async {
    Logger.log("Loading local repository", classId, LogLevel.finest);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String repoJson = prefs.getString("selected_repository") ?? "";
    if (repoJson.isNotEmpty) {
      final RepositoryDetails repo = RepositoryDetails.fromJson(
        Map<String, dynamic>.from(jsonDecode(repoJson)),
      );
      Logger.log("Found local repository: $repoJson", classId, LogLevel.finest);
      _repositories.add(repo);
      _selectedRepository = repo;
      notifyListeners();
    }
  }

  Future<void> getAllUserRepositories() async {
    await loadLocalRepository();
    Logger.log("Fetching repositories", classId, LogLevel.finest);
    _repositories.addAll(
      await (await GithubModel.github).repositories
          .listRepositories(type: "all")
          .where((final repo) => repo.name != _selectedRepository?.name)
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

  Future<void> saveRepository(final RepositoryDetails repository) async {
    Logger.log(
      "Saving repository: ${repository.name} to shared preferences",
      classId,
      LogLevel.finest,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "selected_repository",
      jsonEncode(repository.toJson()),
    );
  }

  void selectRepository(final RepositoryDetails? repo) {
    Logger.log("Selected repository: ${repo?.name}", classId, LogLevel.finest);
    _selectedRepository = repo;
    notifyListeners();
  }
}
