import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/task_edit/task_edit_view_model.dart";
import "package:github_flutter/github.dart";
import "package:multi_dropdown/multi_dropdown.dart";

/// A widget that displays a card for a task item.
class TaskEditView extends StatefulWidget {
  /// Creates a [TaskEditView] widget with the given task.
  const TaskEditView(this.task, {super.key});

  /// The task item to be edited in the view.
  final Task task;

  @override
  State<TaskEditView> createState() => _TaskEditViewState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Task>("task", task));
  }
}

class _TaskEditViewState extends State<TaskEditView> {
  late final TaskEditViewModel _viewModel;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final _labelController = MultiSelectController<IssueLabel>();

  late final List<DropdownItem<IssueLabel>> _allLabels;

  @override
  void initState() {
    super.initState();
    _viewModel = TaskEditViewModel(widget.task);
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    final Set<String> selectedLabels = widget.task.labels
        .map((final label) => label.name)
        .toSet();
    _allLabels = TaskHandler().allLabels
        .map(
          (final label) => DropdownItem(
            label: label.name,
            value: label,
            selected: selectedLabels.contains(label.name),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: const NormalAppBar(),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _editTitle(),
          _editLabels(),
          const Padding(padding: EdgeInsets.all(8)),
          _editDescription(),
          const Padding(padding: EdgeInsets.all(10)),
        ],
      ),
    ),
    floatingActionButton: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: "cancel",
          onPressed: _viewModel.cancel,
          child: const Icon(Icons.cancel_outlined),
        ),
        FloatingActionButton(
          heroTag: "save",
          onPressed: _save,
          child: const Icon(Icons.save),
        ),
      ],
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );

  Widget _editTitle() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: "Title",
        border: OutlineInputBorder(),
      ),
      onSubmitted: _viewModel.updateTitle,
    ),
  );

  MultiDropdown<IssueLabel> _editLabels() => MultiDropdown<IssueLabel>(
    items: _allLabels,
    controller: _labelController,
    searchEnabled: false,
    chipDecoration: ChipDecoration(
      backgroundColor: AppColor.colorScheme.surfaceContainer,
      runSpacing: 4,
      wrap: true,
    ),
    fieldDecoration: FieldDecoration(
      labelText: "Labels",
      showClearIcon: false,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.colorScheme.onSurface),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.colorScheme.primary),
      ),
    ),
    dropdownDecoration: DropdownDecoration(
      marginTop: 4,
      backgroundColor: AppColor.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(6),
      maxHeight: 384, // Max 8 items of 48px height each
    ),
    dropdownItemDecoration: const DropdownItemDecoration(
      selectedIcon: Icon(Icons.check_box),
      selectedBackgroundColor: Colors.transparent,
    ),
    onSelectionChange: _viewModel.updateLabels,
  );

  Widget _editDescription() => TextField(
    controller: _descriptionController,
    decoration: const InputDecoration(
      labelText: "Description",
      border: OutlineInputBorder(),
    ),
    maxLines: null,
    onSubmitted: _viewModel.updateDescription,
  );

  void _save() {
    _viewModel
      ..updateTitle(_titleController.text)
      ..updateDescription(_descriptionController.text)
      ..save();
  }
}
