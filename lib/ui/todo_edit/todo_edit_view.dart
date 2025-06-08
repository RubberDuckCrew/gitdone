import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/_widgets/todo_labels.dart";

/// A widget that displays a card for a task item.
class TodoEditView extends StatefulWidget {
  /// Creates a [TodoEditView] widget with the given task.
  const TodoEditView({required this.todo, super.key});

  /// The task item to be edited in the view.
  final Todo todo;

  @override
  State<TodoEditView> createState() => _TodoEditViewState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Todo>("todo", todo));
  }
}

class _TodoEditViewState extends State<TodoEditView> {
  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: const NormalAppBar(),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitleWidget(title: widget.todo.title),
          TodoLabels(widget.todo),
          const Padding(padding: EdgeInsets.all(8)),
          Text(widget.todo.description),
          const Padding(padding: EdgeInsets.all(8)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Created at: ${_formatDateTime(widget.todo.createdAt)}"),
              if (widget.todo.updatedAt != null)
                Text("Updated at: ${_formatDateTime(widget.todo.updatedAt!)}"),
            ],
          ),
        ],
      ),
    ),
  );

  String _formatDateTime(final DateTime dateTime) =>
      "${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
}
