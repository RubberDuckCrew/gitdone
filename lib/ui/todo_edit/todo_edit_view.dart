import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";

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
    body: Text(widget.todo.toString()),
  );
}
