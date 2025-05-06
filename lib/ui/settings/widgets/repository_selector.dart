import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:github_flutter/github.dart';
import 'package:provider/provider.dart';

class RepositorySelector extends StatefulWidget {
  const RepositorySelector({super.key});

  @override
  State<RepositorySelector> createState() => _RepositorySelectorState();
}

class _RepositorySelectorState extends State<RepositorySelector> {
  DropdownMenuItem<Repository> convertToRepo(Repository repo) {
    return DropdownMenuItem(
      value: repo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            repo.owner!.avatarUrl,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Text(repo.name),
          const SizedBox(width: 8),
          Text("(${repo.owner?.login})", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RepositorySelectorViewModel(),
        child: Consumer<RepositorySelectorViewModel>(
            builder: (context, model, child) {
          if (!model.isReady) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              DropdownButton<Repository>(
                  hint: const Text("Select a repository"),
                  value: model.selectedRepository,
                  items: model.repositories.map(convertToRepo).toList(),
                  onChanged: model.selectRepository),
              // TODO: Add a button to persist the selected repository
            ],
          );
        }));
  }
}

class RepositorySelectorViewModel extends ChangeNotifier {
  final RepositorySelectorModel _model = RepositorySelectorModel();

  List<Repository> get repositories => _model.repositories;
  Repository? get selectedRepository => _model.selectedRepository;
  bool get isReady => _model.isReady;

  RepositorySelectorViewModel() {
    _model.addListener(notifyListeners);
    _model.init().then((value) {
      _model.getAllUserRepositories();
    });
  }

  void selectRepository(Repository? repo) {
    _model.selectRepository(repo);
  }
}

class RepositorySelectorModel extends ChangeNotifier {
  GitHub? _github;
  List<Repository>? _repositories = [];

  Repository? _selectedRepository;
  Repository? get selectedRepository => _selectedRepository;
  bool get isReady => _github != null;
  List<Repository> get repositories => _repositories ?? [];

  Future<bool> init() async {
    log("Calling init method",
        name: "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
        level: 300);
    if (_github == null) {
      String? token = await TokenHandler().getToken();
      _github = GitHub(auth: Authentication.bearerToken(token!));
      log("Initialized GitHub",
          name: "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
          level: 300);
      return true;
    }
    return false;
  }

  void getAllUserRepositories() async {
    if (_github == null) {
      log("Called getAllUserRepositories() while GitHub is null. Initializing...",
          name: "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
          level: 300);
      await init();
    }
    log("Fetching repositories",
        name: "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
        level: 300);
    _repositories =
        await _github!.repositories.listRepositories(type: "all").toList();
    notifyListeners();
  }

  void selectRepository(Repository? repo) {
    log("Selected repository: ${repo?.name}",
        name: "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
        level: 300);
    _selectedRepository = repo;
    notifyListeners();
  }
}
// TODO: How to persist the selected repository across app restarts?
// TODO: Add a method to get the selected repository from local storage
// TODO: Add a method to save the selected repository to local storage
