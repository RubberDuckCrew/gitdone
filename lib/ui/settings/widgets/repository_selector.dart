import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:github_flutter/github.dart';
import 'package:provider/provider.dart';

class Repositoryselector extends StatefulWidget {
  const Repositoryselector({super.key});

  @override
  State<Repositoryselector> createState() => _RepositoryselectorState();
}

class _RepositoryselectorState extends State<Repositoryselector> {
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
          return DropdownButton<Repository>(
              hint: const Text("Select a repository"),
              value: model.selectedRepository,
              items: model.repositories.map(convertToRepo).toList(),
              onChanged: model.selectRepository);
        }));
  }
}

class RepositorySelectorViewModel extends ChangeNotifier {
  List<Repository>? _repositories = [];
  GitHub? _github;
  Repository? _selectedRepository;
  Repository? get selectedRepository => _selectedRepository;
  bool get isReady => _github != null;
  List<Repository> get repositories => _repositories ?? [];

  Future<void> init() async {
    log("Calling init method",
        name: "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
        level: 300);
    if (_github == null) {
      String? token = await TokenHandler().getToken();
      _github = GitHub(auth: Authentication.bearerToken(token!));
      log("Initialized GitHub",
          name: "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
          level: 300);
    }
  }

  RepositorySelectorViewModel() {
    init().then(
      (value) {
        getRepositories();
      },
    );
  }

  void getRepositories() async {
    if (_github == null) {
      log("Called getRepositories() while GitHub is null. Initializing...",
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
