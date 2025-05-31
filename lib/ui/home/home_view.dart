import "package:flutter/material.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/ui/_widgets/todo_card.dart";
import "package:gitdone/ui/home/home_viev_view_model.dart";
import "package:gitdone/ui/home/widgets/dropdown_filter_chip.dart";
import "package:provider/provider.dart";

/// The home view of the app, which is displayed after login.
class HomeView extends StatefulWidget {
  /// Creates a new instance of [HomeView].
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ChangeNotifierProvider(
        create: (_) {
          final model = HomeViewViewModel()..loadTodos();
          return model;
        },
        child: Consumer<HomeViewViewModel>(
          builder: (final context, final model, final child) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: model.updateSearchQuery,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilterChipDropdown(
                      items: [
                        FilterChipItem(value: "Completed", label: "Completed"),
                        FilterChipItem(value: "Pending", label: "Pending"),
                      ],
                      initialLabel: "Filter",
                      allowMultipleSelection: false,
                      onUpdate: (final value) {
                        model.updateFilter(value.value);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChipDropdown(
                      items: [
                        FilterChipItem(
                          value: "Alphabetical",
                          label: "Alphabetical",
                        ),
                        FilterChipItem(
                          value: "Last updated",
                          label: "Last updated",
                        ),
                        FilterChipItem(value: "Created", label: "Created"),
                      ],
                      initialLabel: "Sort",
                      allowMultipleSelection: false,
                      onUpdate: (final value) {
                        model.updateSort(value.value);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChipDropdown(
                      items: model.allLabels
                          .map(
                            (final label) => FilterChipItem(
                              value: label.name,
                              label: label.name,
                            ),
                          )
                          .toList(),
                      initialLabel: "Labels",
                      allowMultipleSelection: true,
                      onUpdate: (final item) {
                        Logger.logInfo(
                          "Selected label: ${item.value}",
                          "HomeView",
                        );
                        model.updateLabels(item.value);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: model.isEmpty
                    ? const Center(
                        child: Text("No Issues found in this repository"),
                      )
                    : model.todos.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () async {
                          model.loadTodos();
                        },
                        child: ListView(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: model.todos
                              .map((final todo) => TodoCard(todo: todo))
                              .toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}
