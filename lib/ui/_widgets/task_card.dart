import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/_widgets/task_labels.dart";
import "package:gitdone/ui/task_details/task_details_view.dart";

/// A widget that displays a card for a task item.
class TaskCard extends StatefulWidget {
  /// Creates a [TaskCard] widget with the given task.
  const TaskCard({required this.task, super.key});

  /// The task item to be displayed in the card.
  final Task task;

  @override
  State<TaskCard> createState() => _TaskCardState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Task>("task", task));
  }
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(4),
    child: GestureDetector(
      onTap: () => Navigation.navigate(TaskDetailsView(widget.task)),
      child: Card(
        color: AppColor.colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            spacing: 16,
            children: [
              const Placeholder(fallbackHeight: 50, fallbackWidth: 50),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    _buildTitle(widget.task.title),
                    TaskLabels(widget.task),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildTitle(final String title) => Text(
    title,
    style: TextStyle(
      color: AppColor.colorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
  );
}
