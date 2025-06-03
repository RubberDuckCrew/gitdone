import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:github_flutter/github.dart";

/// A widget that displays a card for a task item.
class TodoCard extends StatefulWidget {
  /// Creates a [TodoCard] widget with the given task.
  const TodoCard({required this.todo, super.key});

  /// The task item to be displayed in the card.
  final Todo todo;

  @override
  State<TodoCard> createState() => _TodoCardState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Todo>("todo", todo));
  }
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(4),
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
                  _buildTitle(widget.todo.title),
                  _buildLabelChips(widget.todo.labels),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

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

Widget _buildLabelChips(final List<IssueLabel> labels) => SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(spacing: 4, children: _buildLabelList(labels)),
);

List<Widget> _buildLabelList(final List<IssueLabel> labels) {
  if (labels.isNotEmpty) {
    return labels
        .map(
          (final label) => Chip(
            label: Text(label.name),
            backgroundColor: AppColor.colorScheme.surfaceContainer,
            labelStyle: TextStyle(
              color: AppColor.colorScheme.onSurface,
              fontSize: 12,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        )
        .toList();
  } else {
    return [
      const Opacity(
        opacity: 0,
        child: Chip(
          label: Text(""),
          backgroundColor: Colors.transparent,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ),
    ];
  }
}
