import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/dropdown_filter_chip.dart";
import "package:gitdone/ui/_widgets/task_card.dart";
import "package:gitdone/ui/task_list/task_list_view_model.dart";
import "package:provider/provider.dart";

/// A widget that displays a list of task items with search and filter options.
class TaskListView extends StatefulWidget {
  /// Creates a new instance of [TaskListView].
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(final BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ChangeNotifierProvider(
        create: (_) => TaskListViewModel()..loadTasks(),
        child: Consumer<TaskListViewModel>(
          builder: (final context, final model, _) => Column(
            children: [
              _buildSearchField(model),
              _buildFilterRow(model),
              _buildTaskList(model),
            ],
          ),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => TaskListViewModel()..createTask(),
      child: const Icon(Icons.add),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );

  Widget _buildSearchField(final TaskListViewModel model) => Padding(
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

  Widget _buildFilterRow(final TaskListViewModel model) => Padding(
    padding: const EdgeInsets.only(right: 16, left: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
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

  Widget _buildTaskList(final TaskListViewModel model) {
    if (model.isEmpty) {
      return const Expanded(
        child: Center(child: Text("No Issues found in this repository")),
      );
    }
    if (model.tasks.isEmpty) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: RefreshIndicator(
        onRefresh: model.loadTasks,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: model.tasks
              .map((final task) => TaskCard(task: task))
              .toList(),
        ),
      ),
    );
  }
}
