import "package:flutter/cupertino.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:github_flutter/github.dart";
import "package:multi_dropdown/multi_dropdown.dart";

/// A view model for editing a task item.
class TaskEditViewModel extends ChangeNotifier {
  /// Creates a [TaskEditViewModel] with the given task item.
  TaskEditViewModel({
    required final Task task,
    required final titleController,
    required final descriptionController,
    required final labelController,
  }) : _task = task.copy(),
       _titleController = titleController,
       _descriptionController = descriptionController,
       _labelController = labelController {
    _taskHandler.addListener(_listener);
    _titleController.text = _task.title;
    _descriptionController.text = _task.description;
    _labelController.setItems(taskLabels);
  }

  static const _classId =
      "com.GitDone.gitdone.ui.task_edit.task_edit_view_model";

  final Task _task;
  final TaskHandler _taskHandler = TaskHandler();
  final TextEditingController _titleController;
  final TextEditingController _descriptionController;
  final MultiSelectController<IssueLabel> _labelController;

  List<IssueLabel> _repoLabels = [];
  List<DropdownItem<IssueLabel>> _taskLabelItems = [];

  /// Label items for the task being edited.
  List<DropdownItem<IssueLabel>> get taskLabels {
    final List<IssueLabel> currentRepoLabels = _taskHandler.repoLabels;
    if (_taskLabelItems.isEmpty || !identical(_repoLabels, currentRepoLabels)) {
      _repoLabels = currentRepoLabels;
      final Set<String> selectedNames = _task.labels
          .map((final label) => label.name)
          .toSet();
      _taskLabelItems = _repoLabels
          .map(
            (final label) => DropdownItem<IssueLabel>(
              label: label.name,
              value: label,
              selected: selectedNames.contains(label.name),
            ),
          )
          .toList(growable: false);
    }
    return _taskLabelItems;
  }

  void _listener() {
    Logger.log(
      "TaskHandler updated, refreshing task edit view",
      _classId,
      LogLevel.detailed,
    );
    _titleController.text = _task.title;
    _labelController.setItems(taskLabels);
    _descriptionController.text = _task.description;
    notifyListeners();
  }

  @override
  void dispose() {
    Logger.logInfo("Disposing TaskEditViewModel", _classId);
    _taskHandler.removeListener(_listener);
    super.dispose();
  }

  /// Saves the changes made to the task item.
  void save() {
    updateTitle(_titleController.text);
    updateDescription(_descriptionController.text);
    updateLabels(
      _labelController.selectedItems.map((final item) => item.value).toList(),
    );
    Logger.log("Saving task: $_task", _classId, LogLevel.detailed);
    _taskHandler.saveTask(_task);
    _task.updatedAt = DateTime.now();
    _taskHandler.updateLocalTask(_task);
    Navigation.navigateBack(_task);
  }

  /// Cancels the editing of the task item.
  void cancel() {
    Logger.log("Cancel editing task", _classId, LogLevel.detailed);
    Navigation.navigateBack();
  }

  /// Update the title of the task item.
  void updateTitle(final String title) {
    _task.title = title;
    Logger.log("Updated title: $title", _classId, LogLevel.detailed);
  }

  /// Update the labels of the task item.
  void updateLabels(final List<IssueLabel> labels) {
    _task.labels = labels;
    Logger.log("Updated labels: $labels", _classId, LogLevel.detailed);
  }

  /// Update the description of the task item.
  void updateDescription(final String description) {
    _task.description = description;
    Logger.log(
      "Updated description: $description",
      _classId,
      LogLevel.detailed,
    );
  }
}
