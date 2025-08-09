import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/task_edit/task_edit_view_model.dart";
import "package:github_flutter/github.dart";
import "package:multi_dropdown/multi_dropdown.dart";
import "package:provider/provider.dart";

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
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _labelController = MultiSelectController<IssueLabel>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
    create: (_) => TaskEditViewModel(
      task: widget.task,
      titleController: _titleController,
      descriptionController: _descriptionController,
      labelController: _labelController,
    ),
    child: Consumer<TaskEditViewModel>(
      builder: (final context, final viewModel, _) => Scaffold(
        appBar: const NormalAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _editTitle(viewModel),
              _editLabels(viewModel),
              _editDescription(viewModel),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: "cancel",
              onPressed: viewModel.cancel,
              child: const Icon(Icons.cancel_outlined),
            ),
            FloatingActionButton(
              heroTag: "save",
              onPressed: viewModel.save,
              child: const Icon(Icons.save),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    ),
  );

  Widget _editTitle(final TaskEditViewModel viewModel) => TextField(
    controller: _titleController,
    decoration: const InputDecoration(
      labelText: "Title",
      border: OutlineInputBorder(),
    ),
    onSubmitted: viewModel.updateTitle,
  );

  Widget _editLabels(final TaskEditViewModel viewModel) =>
      MultiDropdown<IssueLabel>(
        items: viewModel.taskLabels,
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
        onSelectionChange: viewModel.updateLabels,
      );

  Widget _editDescription(final TaskEditViewModel viewModel) => TextField(
    controller: _descriptionController,
    decoration: const InputDecoration(
      labelText: "Description",
      border: OutlineInputBorder(),
    ),
    maxLines: null,
    onSubmitted: viewModel.updateDescription,
  );
}
