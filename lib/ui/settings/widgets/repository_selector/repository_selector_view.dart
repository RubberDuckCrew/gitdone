import "package:flutter/material.dart";
import "package:gitdone/core/models/repository_details.dart";
import "package:gitdone/core/utils/snack_bar.dart";
import "package:gitdone/ui/settings/widgets/repository_selector/repository_selector_view_model.dart";
import "package:provider/provider.dart";

/// A widget that allows users to select a repository from a dropdown list.
class RepositorySelector extends StatefulWidget {
  /// Creates a widget for selecting a repository.
  const RepositorySelector({super.key});

  @override
  State<RepositorySelector> createState() => _RepositorySelectorState();
}

class _RepositorySelectorState extends State<RepositorySelector> {
  DropdownMenuItem<RepositoryDetails> convertRepoToItem(
    final RepositoryDetails repo,
  ) => DropdownMenuItem(
    value: repo,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(repo.avatarUrl, width: 24, height: 24),
        const Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
        Text(repo.name),
        const Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
        Text("(${repo.owner})", style: const TextStyle(color: Colors.grey)),
      ],
    ),
  );

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
    create: (_) => RepositorySelectorViewModel(),
    child: Consumer<RepositorySelectorViewModel>(
      builder: (final context, final model, final child) => Column(
        children: [
          SizedBox(
            child: DropdownButton<RepositoryDetails>(
              isExpanded: true,
              hint: const Text("Select a repository"),
              value: model.selectedRepository,
              items: model.repositories.map(convertRepoToItem).toList(),
              onChanged: (final repo) {
                model.selectRepository(repo);
                SnackBarUtils.show(
                  context: context,
                  message: "Selected repository: ${repo?.name}",
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
