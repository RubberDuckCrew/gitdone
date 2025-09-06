import "package:flutter/foundation.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/task_edit/task_edit_view.dart";
import "package:gitdone/ui/task_list/task_list_view.dart";

/// A view model for the task details view.
class TaskDetailsViewModel extends ChangeNotifier {
  /// Creates a [TaskDetailsViewModel] with the given task item.
  TaskDetailsViewModel(this.task);

  /// The task item to be displayed in the view.
  final Task task;

  static const _classId =
      "com.GitDone.gitdone.ui.task_details.task_details_view_model";

  /// Starts editing the task.
  Future<void> editTask() async {
    Logger.log("Edit task: ${task.title}", _classId, LogLevel.detailed);
    final Task? updated = await Navigation.navigate(TaskEditView(task));
    if (updated == null) {
      Logger.log("Task edit cancelled or failed", _classId, LogLevel.detailed);
      return;
    }
    task.replace(updated);
    notifyListeners();
    Logger.log("Task updated: ${task.title}", _classId, LogLevel.detailed);
  }

  /// Deletes the task.
  Future<void> deleteTask() async {
    Logger.log("Delete task: ${task.title}", _classId, LogLevel.detailed);
    // TODO(all): Implement deletion confirmation dialog
    await TaskHandler().deleteTask(task);
    Navigation.navigateReplace(const TaskListView());
  }

  /// Marks the task as done.
  Future<void> markTaskAsDone() async {
    final Task updated = await TaskHandler().updateIssueState(
      task,
      IssueState.closed,
    );
    task.replace(updated);
    notifyListeners();
  }

  /// Marks the task as open.
  Future<void> markTaskAsOpen() async {
    final Task updated = await TaskHandler().updateIssueState(
      task,
      IssueState.open,
    );
    task.replace(updated);
    notifyListeners();
  }
}
