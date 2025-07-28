import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/task_labels.dart";
import "package:gitdone/ui/task_edit/task_edit_view_model.dart";

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

  @override
  void initState() {
    super.initState();
    _viewModel = TaskEditViewModel(widget.task);
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
          _editTitle(_viewModel),
          _renderLabels(),
          const Padding(padding: EdgeInsets.all(8)),
          _editDescription(_viewModel),
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

  Widget _editTitle(final TaskEditViewModel viewModel) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: "Title",
        border: OutlineInputBorder(),
      ),
      onSubmitted: viewModel.updateTitle,
    ),
  );

  Widget _renderLabels() => TaskLabels(widget.task);

  Widget _editDescription(final TaskEditViewModel viewModel) => TextField(
    controller: _descriptionController,
    decoration: const InputDecoration(
      labelText: "Description",
      border: OutlineInputBorder(),
    ),
    maxLines: null,
    onSubmitted: viewModel.updateDescription,
  );

  void _save() {
    _viewModel
      ..updateTitle(_titleController.text)
      ..updateDescription(_descriptionController.text)
      ..save();
  }
}
