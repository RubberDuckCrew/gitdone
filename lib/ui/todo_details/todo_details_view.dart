import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/_widgets/todo_labels.dart";
import "package:gitdone/ui/todo_edit/todo_edit_view.dart";
import "package:intl/intl.dart";
import "package:markdown_widget/markdown_widget.dart";

/// A widget that displays a card for a task item.
class TodoDetailsView extends StatefulWidget {
  /// Creates a [TodoDetailsView] widget with the given task.
  const TodoDetailsView(this.todo, {super.key});

  /// The task item to be edited in the view.
  final Todo todo;

  @override
  State<TodoDetailsView> createState() => _TodoDetailsViewState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Todo>("todo", todo));
  }
}

class _TodoDetailsViewState extends State<TodoDetailsView> {
  static const _classId =
      "com.GitDone.gitdone.ui.todo_details.todo_details_view_model";

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: const NormalAppBar(),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderTitle(),
          _renderLabels(),
          const Padding(padding: EdgeInsets.all(8)),
          _renderDescription(),
          const Padding(padding: EdgeInsets.all(8)),
          _renderStatus(),
          const Padding(padding: EdgeInsets.all(8)),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _editTodo,
      child: const Icon(Icons.edit),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );

  Widget _renderTitle() => PageTitleWidget(title: widget.todo.title);

  Widget _renderLabels() => TodoLabels(widget.todo);

  Widget _renderDescription() => SingleChildScrollView(
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

  Widget _renderStatus() => RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 14, height: 1.3, color: Colors.grey),
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
  );

  Future<void> _editTodo() async {
    Logger.log("Edit todo: ${widget.todo.title}", _classId, LogLevel.detailed);
    final Todo? updated =
        await Navigation.navigate(TodoEditView(widget.todo)) as Todo?;
    if (updated == null) {
      Logger.log("Todo edit cancelled or failed", _classId, LogLevel.detailed);
      return;
    }
    setState(() {
      widget.todo.replace(updated);
    });
    Logger.log(
      "Todo updated: ${widget.todo.title}",
      _classId,
      LogLevel.detailed,
    );
  }

  String _formatDateTime(final DateTime dateTime) =>
      DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime.toLocal());
}
