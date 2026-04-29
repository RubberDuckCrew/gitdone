import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/ui/_widgets/mark_task_confirmation_dialog.dart";
import "package:gitdone/ui/task_details/task_details_view_model.dart";

/// Floating action buttons for the task details view.
class TaskDetailsFloatingActionButton extends StatelessWidget {
  /// Creates a [TaskDetailsFloatingActionButton] widget.
  const TaskDetailsFloatingActionButton({required this.viewModel, super.key});

  /// The view model for the task details.
  final TaskDetailsViewModel viewModel;

  @override
  Widget build(final BuildContext context) {
    final _MarkTaskButtonConfig config = _markTaskButtonConfig();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: "markTask",
          onPressed: () => showMarkTaskConfirmationDialog(
            context: context,
            currentTaskState: viewModel.task.state,
            onConfirm: config.onConfirm,
          ),
          child: config.icon,
        ),
        FloatingActionButton(
          heroTag: "editTask",
          onPressed: viewModel.editTask,
          child: const Icon(Icons.edit),
        ),
      ],
    );
  }

  _MarkTaskButtonConfig _markTaskButtonConfig() =>
      viewModel.task.state == IssueState.open.value
      ? (onConfirm: viewModel.markTaskAsDone, icon: const Icon(Icons.done))
      : (onConfirm: viewModel.markTaskAsOpen, icon: const Icon(Icons.undo));

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TaskDetailsViewModel>("viewModel", viewModel),
    );
  }
}

typedef _MarkTaskButtonConfig = ({VoidCallback onConfirm, Icon icon});
