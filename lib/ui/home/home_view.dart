import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/todo_card.dart";
import "package:gitdone/ui/home/home_viev_view_model.dart";
import "package:gitdone/ui/home/widgets/dropdown_filter_chip.dart";
import "package:provider/provider.dart";

/// The home view of the app, displayed after login.
class HomeView extends StatefulWidget {
  /// Creates a new instance of [HomeView].
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(final BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ChangeNotifierProvider(
        create: (_) => HomeViewViewModel()..loadTodos(),
        child: Consumer<HomeViewViewModel>(
          builder: (final context, final model, _) => Column(
            children: [
              _buildSearchField(model),
              _buildFilterRow(model),
              _buildTodoList(model),
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

  Widget _buildSearchField(final HomeViewViewModel model) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Search",
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: model.updateSearchQuery,
    ),
  );

  Widget _buildFilterRow(final HomeViewViewModel model) => Padding(
    padding: const EdgeInsets.only(right: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildFilterChipDropdown(
          items: ["Completed", "Pending"],
          initialLabel: "Filter",
          onUpdate: model.updateFilter,
        ),
        const SizedBox(width: 8),
        _buildFilterChipDropdown(
          items: ["Alphabetical", "Last updated", "Created"],
          initialLabel: "Sort",
          onUpdate: model.updateSort,
        ),
        const SizedBox(width: 8),
        _buildFilterChipDropdown(
          items: model.allLabels.map((final label) => label.name).toList(),
          initialLabel: "Labels",
          allowMultipleSelection: true,
          onUpdate: model.updateLabels,
        ),
      ],
    ),
  );

  Widget _buildFilterChipDropdown({
    required final List<String> items,
    required final String initialLabel,
    required final Function(String) onUpdate,
    final bool allowMultipleSelection = false,
  }) => FilterChipDropdown(
    items: items
        .map((final item) => FilterChipItem(value: item, label: item))
        .toList(),
    initialLabel: initialLabel,
    allowMultipleSelection: allowMultipleSelection,
    onUpdate: (final item) => onUpdate(item.value),
  );

  Widget _buildTodoList(final HomeViewViewModel model) {
    if (model.isEmpty) {
      return const Center(child: Text("No Issues found in this repository"));
    }
    if (model.todos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Expanded(
      child: RefreshIndicator(
        onRefresh: model.loadTodos,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: model.todos
              .map((final todo) => TodoCard(todo: todo))
              .toList(),
        ),
      ),
    );
  }
}
