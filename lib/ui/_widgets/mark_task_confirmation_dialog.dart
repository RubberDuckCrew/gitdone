import "package:flutter/material.dart";
import "package:gitdone/core/settings_handler.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/ui/_widgets/confirm_dialog.dart";

/// Shows a confirmation dialog for marking a task as done or open.
///
/// If the "don't ask again" setting is enabled, it will execute [onConfirm] immediately.
Future<void> showMarkTaskConfirmationDialog({
  required BuildContext context,
  required String currentTaskState,
  required VoidCallback onConfirm,
}) async {
  final _DialogTexts texts = currentTaskState == IssueState.open.value
      ? (
          title: "Mark as done",
          description: "Are you sure you want to mark this task as done? This will close the GitHub issue.",
          confirmText: "Mark as done",
        )
      : (
          title: "Reopen task",
          description: "Are you sure you want to reopen this task?",
          confirmText: "Reopen",
        );

  if (!SettingsHandler().showMarkTaskStateConfirmation()) {
    onConfirm();
    return;
  }

  bool doNotAskAgain = false;
  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => ConfirmDialog(
        title: Text(texts.title),
        content: _buildDialogContent(
          description: texts.description,
          doNotAskAgain: doNotAskAgain,
          onChanged: (value) => setState(() => doNotAskAgain = value),
        ),
        confirmText: texts.confirmText,
        onConfirm: () async {
          if (doNotAskAgain) {
            await SettingsHandler().setShowMarkTaskStateConfirmation(
              value: false,
            );
          }
          onConfirm();
        },
        cancelText: "Cancel",
      ),
    ),
  );
}

Widget _buildDialogContent({
  required String description,
  required bool doNotAskAgain,
  required ValueChanged<bool> onChanged,
}) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(description),
    Row(
      children: [
        Checkbox(
          value: doNotAskAgain,
          onChanged: (value) => onChanged(value ?? false),
        ),
        const Text("Don't ask me again"),
      ],
    ),
  ],
);

typedef _DialogTexts = ({String title, String description, String confirmText});
