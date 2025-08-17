import "package:flutter/foundation.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/task_edit/task_edit_view.dart";

/// A view model for the task details view.
class TaskDetailsViewModel extends ChangeNotifier {
  /// Creates a [TaskDetailsViewModel] with the given task item.
  TaskDetailsViewModel(this._task);

  final Task _task;

  static const _classId =
      "com.GitDone.gitdone.ui.task_details.task_details_view_model";

  /// Starts editing the task.
  Future<void> editTask() async {
    Logger.log("Edit task: ${_task.title}", _classId, LogLevel.detailed);
    final Task? updated = await Navigation.navigate(TaskEditView(_task));
    if (updated == null) {
      Logger.log("Task edit cancelled or failed", _classId, LogLevel.detailed);
      return;
    }
    _task.replace(updated);
    notifyListeners();
    Logger.log("Task updated: ${_task.title}", _classId, LogLevel.detailed);
  }

  /// Deletes the task.
  Future<void> deleteTask() async {
    Logger.log("Delete task: ${_task.title}", _classId, LogLevel.detailed);
    // TODO: Implement deletion confirmation dialog
    TaskHandler().deleteTask(_task);
  }
}
