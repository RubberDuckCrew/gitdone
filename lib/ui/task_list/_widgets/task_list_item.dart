import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:gitdone/ui/_widgets/mark_task_confirmation_dialog.dart";
import "package:gitdone/ui/_widgets/task_card.dart";

/// A widget that displays a single task item in the task list with swipe-to-dismiss functionality.
class TaskListItem extends StatelessWidget {
  /// Creates a new instance of [TaskListItem].
  const TaskListItem({required this.task, super.key});

  /// The task to display.
  final Task task;

  @override
  Widget build(final BuildContext context) {
    final _ItemConfig config = task.state == IssueState.open.value
        ? (icon: Icons.done, label: "Mark as done", newState: IssueState.closed)
        : (icon: Icons.undo, label: "Reopen task", newState: IssueState.open);

    return Dismissible(
      key: ValueKey(task.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: AppColor.colorScheme.primary,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(config.icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(config.label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
      confirmDismiss: (final direction) async {
        bool confirmed = false;
        await showMarkTaskConfirmationDialog(
          context: context,
          currentTaskState: task.state,
          onConfirm: () => confirmed = true,
        );
        return confirmed;
      },
      onDismissed: (final direction) =>
          TaskHandler().updateIssueState(task, config.newState),
      child: TaskCard(task: task),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Task>("task", task));
  }
}

typedef _ItemConfig = ({IconData icon, String label, IssueState newState});
