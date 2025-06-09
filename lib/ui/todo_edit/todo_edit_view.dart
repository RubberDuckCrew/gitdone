import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/_widgets/todo_labels.dart";
import "package:gitdone/ui/todo_edit/todo_edit_view_model.dart";
import "package:markdown_widget/markdown_widget.dart";
import "package:provider/provider.dart";

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
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(
      text: widget.todo.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
    create: (_) => TodoEditViewModel(widget.todo),
    child: Consumer<TodoEditViewModel>(
      builder: (final context, final viewModel, final child) => Scaffold(
        appBar: const NormalAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!viewModel.isEditing)
                _renderTitle()
              else
                _editTitle(viewModel),
              _renderLabels(),
              const Padding(padding: EdgeInsets.all(8)),
              if (!viewModel.isEditing)
                _renderDescription()
              else
                _editDescription(viewModel),
              const Padding(padding: EdgeInsets.all(8)),
              if (!viewModel.isEditing) _renderStatus(),
              const Padding(padding: EdgeInsets.all(8)),
            ],
          ),
        ),
        floatingActionButton: !viewModel.isEditing
            ? FloatingActionButton(
                onPressed: viewModel.edit,
                child: const Icon(Icons.edit),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    onPressed: viewModel.cancel,
                    child: const Icon(Icons.cancel_outlined),
                  ),
                  FloatingActionButton(
                    onPressed: () => _save(viewModel),
                    child: const Icon(Icons.save),
                  ),
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    ),
  );

  Widget _renderTitle() => PageTitleWidget(title: widget.todo.title);

  Widget _editTitle(final TodoEditViewModel viewModel) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: "Title",
        border: OutlineInputBorder(),
      ),
      onSubmitted: viewModel.updateTitle,
    ),
  );

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

  Widget _editDescription(final TodoEditViewModel viewModel) => TextField(
    controller: _descriptionController,
    decoration: const InputDecoration(
      labelText: "Description",
      border: OutlineInputBorder(),
    ),
    maxLines: null,
    onSubmitted: viewModel.updateDescription,
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

  void _save(final TodoEditViewModel viewModel) {
    viewModel
      ..updateTitle(_titleController.text)
      ..updateDescription(_descriptionController.text)
      ..save();
  }

  String _formatDateTime(final DateTime dateTime) =>
      "${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
}
