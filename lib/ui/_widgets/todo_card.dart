import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/core/theme/app_color.dart";

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
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Placeholder(fallbackHeight: 50, fallbackWidth: 50),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Text(
                    widget.todo.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColor.colorScheme.onSurface,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.todo.labels.isNotEmpty
                          ? widget.todo.labels
                                .map(
                                  (final label) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Chip(
                                      label: Text(label.name),
                                      backgroundColor:
                                          AppColor.colorScheme.surfaceContainer,
                                      labelStyle: TextStyle(
                                        color: AppColor.colorScheme.onSurface,
                                        fontSize: 12,
                                      ),
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                )
                                .toList()
                          : [
                              const Opacity(
                                opacity: 0,
                                child: Chip(
                                  label: Text(""),
                                  backgroundColor: Colors.transparent,
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
