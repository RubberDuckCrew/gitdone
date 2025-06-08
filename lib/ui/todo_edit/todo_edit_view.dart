import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/_widgets/todo_labels.dart";
import "package:markdown_widget/markdown_widget.dart";

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
          _buildDescription(),
          const Padding(padding: EdgeInsets.all(8)),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                height: 1.3,
                color: Colors.grey,
              ),
              children: [
                const TextSpan(
                  text: "Created at: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: _formatDateTime(widget.todo.createdAt)),
                if (widget.todo.updatedAt != null) ...[
                  const TextSpan(text: "\n"),
                  const TextSpan(
                    text: "Updated at: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: _formatDateTime(widget.todo.updatedAt!)),
                ],
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(8)),
        ],
      ),
    ),
  );

  Widget _buildDescription() => SingleChildScrollView(
    child: MarkdownBlock(
      data: widget.todo.description,
      selectable: false,
      config: MarkdownConfig.darkConfig.copy(
        configs: [
          CodeConfig(
            style: CodeConfig.darkConfig.style.copyWith(
              fontFamily: "monospace",
            ),
          ),
        ],
      ),
    ),
  );

  String _formatDateTime(final DateTime dateTime) =>
      "${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
}
