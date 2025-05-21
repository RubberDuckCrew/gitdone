import 'package:flutter/material.dart';
import 'package:gitdone/core/models/repository_details.dart';
import 'package:gitdone/ui/_widgets/advanced_filled_button.dart';
import 'package:provider/provider.dart';

import 'repository_selector_view_model.dart';

class RepositorySelector extends StatefulWidget {
  const RepositorySelector({super.key});

  @override
  State<RepositorySelector> createState() => _RepositorySelectorState();
}

class _RepositorySelectorState extends State<RepositorySelector> {
  DropdownMenuItem<RepositoryDetails> convertRepoToItem(
    RepositoryDetails repo,
  ) {
    return DropdownMenuItem(
      value: repo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(repo.avatarUrl, width: 24, height: 24),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
          Text(repo.name),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
          Text("(${repo.owner})", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void showSnackBar(String message) {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RepositorySelectorViewModel(),
      child: Consumer<RepositorySelectorViewModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: DropdownButton<RepositoryDetails>(
                  hint: const Text("Select a repository"),
                  value: model.selectedRepository,
                  items: model.repositories.map(convertRepoToItem).toList(),
                  onChanged: model.selectRepository,
                ),
              ),
              const SizedBox(height: 16),
              AdvancedFilledButton(
                onPressed: () {
                  model.saveSelectedRepository();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Repository saved successfully"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                enabled: model.selectedRepository != null,
                child: Text("Save Repository"),
              ),
            ],
          );
        },
      ),
    );
  }
}
