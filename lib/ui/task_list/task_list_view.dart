import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/dropdown_filter_chip.dart";
import "package:gitdone/ui/_widgets/task_card.dart";
import "package:gitdone/ui/task_list/task_list_view_model.dart";
import "package:github_flutter/src/models/issues.dart";
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
  List<FilterChipItem<String>>? _labelItems;

  void _ensureFilterChips(final TaskListViewModel model) {
    final filterOptions = ["Pending", "Completed"];
    final sortOptions = ["Alphabetical", "Last updated", "Created"];
    final List<IssueLabel> allLabels = model.allLabels;
    _filterItems ??= filterOptions
        .map(
          (final option) => FilterChipItem<String>(
            value: option,
            selected: option == "Pending",
          ),
        )
        .toList();
    _sortItems ??= sortOptions
        .map(
          (final option) => FilterChipItem<String>(
            value: option,
            selected: option == "Created",
          ),
        )
        .toList();
    // Race condition with task handler:
    // labels may not be loaded yet (can take over 1 sec.)
    _labelItems = allLabels.isNotEmpty
        ? allLabels
              .map((final label) => FilterChipItem<String>(value: label.name))
              .toList()
        : <FilterChipItem<String>>[];
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ChangeNotifierProvider(
        create: (_) => TaskListViewModel()..loadTasks(),
        child: Consumer<TaskListViewModel>(
          builder: (final context, final model, _) {
            _ensureFilterChips(model);
            return Column(
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
        _buildFilterChipDropdown(
          items: _labelItems!,
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
