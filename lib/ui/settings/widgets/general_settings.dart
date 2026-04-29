import "package:flutter/material.dart";
import "package:gitdone/ui/settings/widgets/confirm_task_status_change_setting.dart";

/// A widget that allows users to manage general application settings.
class GeneralSettings extends StatelessWidget {
  /// Creates an instance of [GeneralSettings].
  const GeneralSettings({super.key});

  @override
  Widget build(final BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("General Settings", style: Theme.of(context).textTheme.titleLarge),
      const ConfirmTaskStatusChangeSetting(),
    ],
  );
}
