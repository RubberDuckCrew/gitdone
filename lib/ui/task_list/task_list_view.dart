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
          items: [
            FilterChipItem<String>(value: "Pending", selected: true),
            FilterChipItem<String>(value: "Completed"),
          ],
          initialLabel: "Filter",
          onUpdate: model.updateFilter,
        ),
        const SizedBox(width: 8),
        _buildFilterChipDropdown(
          items: [
            FilterChipItem<String>(value: "Alphabetical"),
            FilterChipItem<String>(value: "Last updated"),
            FilterChipItem<String>(value: "Created", selected: true),
          ],
          initialLabel: "Sort",
          onUpdate: model.updateSort,
        ),
        const SizedBox(width: 8),
        _buildFilterChipDropdown(
          items: model.allLabels
              .map((final label) => label.name)
              .map((final value) => FilterChipItem(value: value))
              .toList(),
          initialLabel: "Labels",
          allowMultipleSelection: true,
          onUpdate: model.updateLabels,
        ),
      ],
    ),
  );

  Widget _buildFilterChipDropdown({
    required final List<FilterChipItem<String>> items,
    required final String initialLabel,
    required final Function(String, {required bool selected}) onUpdate,
    final bool allowMultipleSelection = false,
  }) => FilterChipDropdown<String>(
    items: items,
    initialLabel: initialLabel,
    allowMultipleSelection: allowMultipleSelection,
    onUpdate: (final item, {required final selected}) =>
        onUpdate(item.value, selected: selected),
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
