import 'package:flutter/material.dart';
import 'package:gitdone/core/models/repository_details.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(repo.avatarUrl, width: 24, height: 24),
          Padding(padding: const EdgeInsets.fromLTRB(0, 0, 8, 0)),
          Text(repo.name),
          Padding(padding: const EdgeInsets.fromLTRB(0, 0, 8, 0)),
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
          return Column(
            children: [
              SizedBox(
                child: DropdownButton<RepositoryDetails>(
                  isExpanded: true,
                  hint: const Text("Select a repository"),
                  value: model.selectedRepository,
                  items: model.repositories.map(convertRepoToItem).toList(),
                  onChanged: (repo) {
                    model.selectRepository(repo);
                    model.saveSelectedRepository();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Selected repository: ${repo?.name}"),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
