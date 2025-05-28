import "package:flutter/material.dart";
import "package:gitdone/core/models/repository_details.dart";

import "package:gitdone/ui/settings/widgets/repository_selector/repository_selector_model.dart";

class RepositorySelectorViewModel extends ChangeNotifier {
  RepositorySelectorViewModel() {
    _model.addListener(notifyListeners);
    _model.clearRepositories();
    _model.getAllUserRepositories();
  }
  final RepositorySelectorModel _model = RepositorySelectorModel();

  List<RepositoryDetails> get repositories => _model.repositories;

  RepositoryDetails? get selectedRepository => _model.selectedRepository;

  void selectRepository(final RepositoryDetails? repo) {
    _model.selectRepository(repo);
  }

  Future<void> saveSelectedRepository() async {
    if (selectedRepository != null) {
      _model.saveRepository(selectedRepository!);
    }
  }
}
