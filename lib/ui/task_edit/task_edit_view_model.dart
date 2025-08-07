import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:github_flutter/github.dart";

/// A view model for editing a task item.
class TaskEditViewModel {
  /// Creates a [TaskEditViewModel] with the given task item.
  TaskEditViewModel(this._originalTask) : newTask = _originalTask.copy();

  static const _classId =
      "com.GitDone.gitdone.ui.task_edit.task_edit_view_model";

  final Task _originalTask;

  /// The updated task item that is being edited.
  final Task newTask;

  /// Cancels the editing of the task item.
  void cancel() {
    Logger.log("Cancel editing task", _classId, LogLevel.detailed);
    Navigation.navigateBack();
  }

  /// Saves the changes made to the task item.
  void save() {
    Logger.log("Saving task: $newTask", _classId, LogLevel.detailed);
    TaskHandler().saveTask(newTask);
    newTask.updatedAt = DateTime.now();
    TaskHandler().updateLocalTask(newTask);

    _originalTask.replace(newTask);
    Navigation.navigateBack(newTask);
  }

  /// Update the title of the task item.
  void updateTitle(final String title) {
    newTask.title = title;
    Logger.log("Updated title: $title", _classId, LogLevel.detailed);
  }

  /// Update the labels of the task item.
  void updateLabels(final List<IssueLabel> labels) {
    newTask.labels = labels;
    Logger.log("Updated labels: $labels", _classId, LogLevel.detailed);
  }

  /// Update the description of the task item.
  void updateDescription(final String description) {
    newTask.description = description;
    Logger.log(
      "Updated description: $description",
      _classId,
      LogLevel.detailed,
    );
  }
}
