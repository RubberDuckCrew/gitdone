import "package:flutter/material.dart";
import "package:gitdone/core/models/github_model.dart";
import "package:gitdone/core/models/repository_details.dart";
import "package:gitdone/core/settings_handler.dart";
import "package:gitdone/core/utils/logger.dart";

/// Model for managing repository selection in the settings.
class RepositorySelectorModel extends ChangeNotifier {
  /// Class identifier for logging purposes.
  static const _classId =
      "com.GitDone.gitdone.ui.settings.widgets.repository_selector.repository_selector_model";

  final List<RepositoryDetails> _repositories = [];

  /// The list of repositories available for selection.
  List<RepositoryDetails> get repositories => _repositories;

  RepositoryDetails? _selectedRepository;

  /// The currently selected repository.
  RepositoryDetails? get selectedRepository => _selectedRepository;

  /// Checks if a repository is selected.
  bool get locallySavedRepoExist => _selectedRepository != null;

  /// Loads local repository if available.
  Future<void> loadLocalRepository() async {
    Logger.log("Loading local repository", _classId, LogLevel.finest);
    final RepositoryDetails? repo = await SettingsHandler()
        .getSelectedRepository();
    if (repo == null) {
      Logger.log("No local repository found", _classId, LogLevel.finest);
      return;
    }
    Logger.log(
      "Found local repository: ${repo.name}",
      _classId,
      LogLevel.finest,
    );
    _repositories.add(repo);
    _selectedRepository = repo;
    notifyListeners();
  }

  /// Fetches all user repositories from GitHub and adds them to the list,
  Future<void> getAllUserRepositories() async {
    Logger.log("Fetching repositories", _classId, LogLevel.finest);
    _repositories
      ..clear()
      ..addAll(
        await (await GithubModel.github).repositories
            .listRepositories(type: "all")
            .where((final repo) => repo.name != _selectedRepository?.name)
            .map(RepositoryDetails.fromRepository)
            .toList(),
      );
    notifyListeners();
  }

  /// Selects a repository from the list and updates the selected repository.
  Future<void> selectRepository(final RepositoryDetails? repo) async {
    if (repo == null) {
      Logger.log("No repository selected", _classId, LogLevel.finest);
      return;
    }
    _selectedRepository = repo;
    await SettingsHandler().setSelectedRepository(repo);
    notifyListeners();
    Logger.log("Selected repository: ${repo.name}", _classId, LogLevel.finest);
  }
}
