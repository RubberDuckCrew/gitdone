import "package:flutter/material.dart";
import "package:gitdone/core/models/todo/todo.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:github_flutter/github.dart";

/// A widget that displays the labels of a to do item.
class TodoLabels extends StatelessWidget {
  /// Creates a widget that displays the labels of a to do item.
  const TodoLabels(this._todo, {super.key});

  final Todo _todo;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(spacing: 4, children: _buildLabelList(_todo.labels)),
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
}
