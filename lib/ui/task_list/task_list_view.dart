import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/filter_chip/filter_chip_dropdown.dart";
import "package:gitdone/ui/_widgets/filter_chip/filter_chip_item.dart";
import "package:gitdone/ui/task_list/_widgets/task_list_item.dart";
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
  List<FilterChipItem<String>>? _filterItems;
  List<FilterChipItem<String>>? _sortItems;

  void _getFilterItems() {
    _filterItems ??= TaskListViewModel.filterOptions
        .map(
          (option) => FilterChipItem<String>(
            value: option,
            selected: option == TaskListViewModel.defaultFilter,
          ),
        )
        .toList();
  }

  void _getSortItems() {
    _sortItems ??= TaskListViewModel.sortOptions
        .map(
          (option) => FilterChipItem<String>(
            value: option,
            selected: option == TaskListViewModel.defaultSort,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ChangeNotifierProvider(
        create: (_) => TaskListViewModel()..loadTasks(),
        child: Consumer<TaskListViewModel>(
          builder: (context, model, _) {
            _getFilterItems();
            _getSortItems();
            return Column(
              spacing: 8,
              children: [
                _buildSearchField(model),
                _buildFilterRow(model),
                _buildTaskList(model),
              ],
            );
          },
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => TaskListViewModel()..createTask(),
      child: const Icon(Icons.add),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );

  Widget _buildSearchField(TaskListViewModel model) => TextField(
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: "Search",
      prefixIcon: Icon(Icons.search),
    ),
    onChanged: model.updateSearchQuery,
  );

  Widget _buildFilterRow(TaskListViewModel model) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      _buildFilterChipDropdown(
        items: _filterItems!,
        initialLabel: "Filter",
        onUpdate: model.updateFilter,
      ),
      const SizedBox(width: 8),
      _buildFilterChipDropdown(
        items: _sortItems!,
        initialLabel: "Sort",
        onUpdate: model.updateSort,
      ),
      const SizedBox(width: 8),
      Consumer<TaskListViewModel>(
        builder: (context, model, _) => _buildFilterChipDropdown(
          items: model.labelFilterChipItems,
          initialLabel: "Labels",
          allowMultipleSelection: true,
          onUpdate: model.updateLabels,
        ),
      ),
    ],
  );

  Widget _buildFilterChipDropdown({
    required List<FilterChipItem<String>> items,
    required String initialLabel,
    required Function(String, {required bool selected}) onUpdate,
    bool allowMultipleSelection = false,
  }) => FilterChipDropdown<String>(
    items: items,
    initialLabel: initialLabel,
    allowMultipleSelection: allowMultipleSelection,
    onUpdate: (item, {required selected}) =>
        onUpdate(item.value, selected: selected),
  );

  Widget _buildTaskList(TaskListViewModel model) {
    if (model.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    if (model.tasks.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            "No Issues matching current filters found in this repository",
          ),
        ),
      );
    }
    return Expanded(
      child: RefreshIndicator(
        onRefresh: model.loadTasks,
        child: ListView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: model.tasks
              .map(
                (task) => TaskListItem(
                  task: task,
                  key: ValueKey("${task.slug}#${task.issueNumber}"),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
