import "package:flutter/material.dart";
import "package:gitdone/core/settings_handler.dart";

/// A setting widget that allows users to toggle the confirmation dialog for task status changes.
class ConfirmTaskStatusChangeSetting extends StatelessWidget {
  /// Creates an instance of [ConfirmTaskStatusChangeSetting].
  const ConfirmTaskStatusChangeSetting({super.key});

  @override
  Widget build(final BuildContext context) => ListenableBuilder(
    listenable: SettingsHandler(),
    builder: (final context, final child) => SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text("Confirm task status change"),
      subtitle: const Text(
        "Ask for confirmation before marking a task as done or reopening it.",
      ),
      value: SettingsHandler().showMarkTaskStateConfirmation(),
      onChanged: (final value) =>
          SettingsHandler().setShowMarkTaskStateConfirmation(value: value),
    ),
  );
}
