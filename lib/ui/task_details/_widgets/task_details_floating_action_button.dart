import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/settings_handler.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/ui/_widgets/confirm_dialog.dart";
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
          onPressed: () => _showMarkTaskDialog(context, config),
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
      ? (
          title: "Mark as done",
          description:
              "Are you sure you want to mark this task as done? This will close the GitHub issue.",
          confirmText: "Mark as done",
          onConfirm: viewModel.markTaskAsDone,
          icon: const Icon(Icons.done),
        )
      : (
          title: "Reopen task",
          description: "Are you sure you want to reopen this task?",
          onConfirm: viewModel.markTaskAsOpen,
          icon: const Icon(Icons.undo),
          confirmText: "Reopen",
        );

  Future<void> _showMarkTaskDialog(
    final BuildContext context,
    final _MarkTaskButtonConfig config,
  ) async {
    if (!SettingsHandler().showMarkTaskStateConfirmation()) {
      config.onConfirm();
      return;
    }
    bool doNotAskAgain = false;
    await showDialog(
      context: context,
      builder: (final context) => StatefulBuilder(
        builder: (final context, final setState) => ConfirmDialog(
          title: Text(config.title),
          content: _buildDialogContent(
            description: config.description,
            doNotAskAgain: doNotAskAgain,
            onChanged: (final value) => setState(() => doNotAskAgain = value),
          ),
          confirmText: config.confirmText,
          onConfirm: () {
            if (doNotAskAgain) {
              SettingsHandler().setShowMarkTaskStateConfirmation(value: false);
            }
            config.onConfirm();
          },
          cancelText: "Cancel",
        ),
      ),
    );
  }

  Widget _buildDialogContent({
    required final String description,
    required final bool doNotAskAgain,
    required final ValueChanged<bool> onChanged,
  }) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(description),
      Row(
        children: [
          Checkbox(
            value: doNotAskAgain,
            onChanged: (final value) => onChanged(value ?? false),
          ),
          const Text("Don't ask me again"),
        ],
      ),
    ],
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TaskDetailsViewModel>("viewModel", viewModel),
    );
  }
}

typedef _MarkTaskButtonConfig = ({
  String confirmText,
  String description,
  String title,
  VoidCallback onConfirm,
  Icon icon,
});
