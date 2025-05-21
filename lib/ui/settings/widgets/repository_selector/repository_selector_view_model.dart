import 'package:flutter/material.dart';
import 'package:gitdone/core/models/repository_details.dart';

import 'repository_selector_model.dart';

class RepositorySelectorViewModel extends ChangeNotifier {
  final RepositorySelectorModel _model = RepositorySelectorModel();

  List<RepositoryDetails> get repositories => _model.repositories;
  RepositoryDetails? get selectedRepository => _model.selectedRepository;

  RepositorySelectorViewModel() {
    _model.addListener(notifyListeners);
    _model.init().then((value) {
      _model.clearRepositories();
      _model.getAllUserRepositories();
    });
  }

  void selectRepository(RepositoryDetails? repo) {
    _model.selectRepository(repo);
  }

  void saveSelectedRepository() async {
    if (selectedRepository != null) {
      _model.saveRepository(selectedRepository!);
    }
  }
}
