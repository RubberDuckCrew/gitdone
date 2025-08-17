import "package:flutter/material.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:gitdone/ui/_widgets/filter_chip/filter_chip_dropdown.dart";
import "package:gitdone/ui/_widgets/filter_chip/filter_chip_item.dart";
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
  List<FilterChipItem<String>>? _filterItems;
  List<FilterChipItem<String>>? _sortItems;

  void _getFilterItems() {
    _filterItems ??= TaskListViewModel.filterOptions
        .map(
          (final option) => FilterChipItem<String>(
            value: option,
            selected: option == TaskListViewModel.defaultFilter,
          ),
        )
        .toList();
  }

  void _getSortItems() {
    _sortItems ??= TaskListViewModel.sortOptions
        .map(
          (final option) => FilterChipItem<String>(
            value: option,
            selected: option == TaskListViewModel.defaultSort,
          ),
        )
        .toList();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ChangeNotifierProvider(
        create: (_) => TaskListViewModel()..loadTasks(),
        child: Consumer<TaskListViewModel>(
          builder: (final context, final model, _) {
            _getFilterItems();
            _getSortItems();
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
        Consumer<TaskListViewModel>(
          builder: (final context, final model, _) => _buildFilterChipDropdown(
            items: model.labelFilterChipItems,
            initialLabel: "Labels",
            allowMultipleSelection: true,
            onUpdate: model.updateLabels,
          ),
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
                (final task) => task.state == IssueState.open.value
                    ? Dismissible(
                        key: ValueKey(task.issueNumber),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: AppColor.colorScheme.primary,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            children: [
                              Text("Mark as done"),
                              Icon(Icons.done, color: Colors.white),
                            ],
                          ),
                        ),
                        onDismissed: (_) {
                          TaskHandler().updateIssueState(
                            task,
                            IssueState.closed,
                          );
                        },
                        child: TaskCard(task: task),
                      )
                    : TaskCard(task: task),
              )
              .toList(),
        ),
      ),
    );
  }
}
