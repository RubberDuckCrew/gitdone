import 'package:flutter/material.dart';
import 'package:gitdone/core/models/repository_details.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/core/utils/logger.dart';
import 'package:github_flutter/github.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositorySelector extends StatefulWidget {
  const RepositorySelector({super.key});

  @override
  State<RepositorySelector> createState() => _RepositorySelectorState();
}

class _RepositorySelectorState extends State<RepositorySelector> {
  DropdownMenuItem<RepositoryDetails> convertToRepo(RepositoryDetails repo) {
    return DropdownMenuItem(
      value: repo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            repo.avatarUrl,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Text(repo.name),
          const SizedBox(width: 8),
          Text("(${repo.owner})", style: TextStyle(color: Colors.grey)),
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
              DropdownButton<RepositoryDetails>(
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

  List<RepositoryDetails> get repositories => _model.repositories;
  RepositoryDetails? get selectedRepository => _model.selectedRepository;
  bool get isReady => _model.isReady;

  RepositorySelectorViewModel() {
    _model.addListener(notifyListeners);
    _model.init().then((value) {
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

class RepositorySelectorModel extends ChangeNotifier {
  GitHub? _github;
  List<RepositoryDetails>? _repositories = [];

  RepositoryDetails? _selectedRepository;
  RepositoryDetails? get selectedRepository => _selectedRepository;
  bool get isReady => _github != null;
  List<RepositoryDetails> get repositories => _repositories ?? [];

  Future<bool> init() async {
    Logger.log(
        "Calling init method",
        "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
        LogLevel.finest);
    if (_github == null) {
      String? token = await TokenHandler().getToken();
      _github = GitHub(auth: Authentication.bearerToken(token!));
      Logger.log(
          "Initialized GitHub",
          "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
          LogLevel.finest);
      return true;
    }
    return false;
  }

  void getAllUserRepositories() async {
    if (_github == null) {
      Logger.log(
          "Called getAllUserRepositories() while GitHub is null. Initializing...",
          "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
          LogLevel.finest);
      await init();
    }
    Logger.log(
        "Fetching repositories",
        "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
        LogLevel.finest);
    _repositories = await _github!.repositories
        .listRepositories(type: "all")
        .map(RepositoryDetails.fromRepository)
        .toList();
    notifyListeners();
  }

  void saveRepository(RepositoryDetails repository) async {
    Logger.log(
        "Saving repository: ${repository.name} to shared preferences",
        "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
        LogLevel.finest);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'selected_repository', repository.toJson().toString());
  }

  void selectRepository(RepositoryDetails? repo) {
    Logger.log(
        "Selected repository: ${repo?.name}",
        "com.GitDone.gitdone.ui.settings.widgets.repository_selector",
        LogLevel.finest);
    _selectedRepository = repo;
    notifyListeners();
  }
}
// TODO: How to persist the selected repository across app restarts?
// TODO: Add a method to get the selected repository from local storage
// TODO: Add a method to save the selected repository to local storage
