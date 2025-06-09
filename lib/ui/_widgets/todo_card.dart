import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:gitdone/ui/_widgets/todo_labels.dart";
import "package:gitdone/ui/todo_details/todo_details_view.dart";

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
    child: GestureDetector(
      onTap: () => _openTodoDetailsView(context, widget.todo),
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
                    TodoLabels(widget.todo),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void _openTodoDetailsView(final BuildContext context, final Todo todo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (final context) => TodoDetailsView(todo)),
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
}
