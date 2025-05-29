import "package:flutter/material.dart";
import "package:gitdone/core/models/repository_details.dart";
import "package:gitdone/ui/settings/widgets/repository_selector/repository_selector_model.dart";

/// ViewModel for managing the state of the repository selector widget.
class RepositorySelectorViewModel extends ChangeNotifier {
  /// Creates an instance of [RepositorySelectorViewModel].
  RepositorySelectorViewModel() {
    _model
      ..addListener(notifyListeners)
      ..clearRepositories()
      ..getAllUserRepositories();
  }
  final RepositorySelectorModel _model = RepositorySelectorModel();

  /// The list of repositories available for selection.
  List<RepositoryDetails> get repositories => _model.repositories;

  /// The currently selected repository.
  RepositoryDetails? get selectedRepository => _model.selectedRepository;

  /// Selects a repository from the list of available repositories.
  void selectRepository(final RepositoryDetails? repo) {
    _model.selectRepository(repo);
  }

  /// Saves the currently selected repository to local storage.
  Future<void> saveSelectedRepository() async {
    if (selectedRepository != null) {
      _model.saveRepository(selectedRepository!);
    }
  }
}
