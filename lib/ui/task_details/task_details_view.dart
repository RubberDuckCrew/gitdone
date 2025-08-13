import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/models/task.dart";
import "package:gitdone/core/task_handler.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/_widgets/task_labels.dart";
import "package:gitdone/ui/task_edit/task_edit_view.dart";
import "package:intl/intl.dart";
import "package:markdown_widget/markdown_widget.dart";
import "package:provider/provider.dart";

/// A widget that displays a card for a task item.
class TaskDetailsView extends StatefulWidget {
  /// Creates a [TaskDetailsView] widget with the given task.
  const TaskDetailsView(this.task, {super.key});

  /// The task item to be edited in the view.
  final Task task;

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Task>("task", task));
  }
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  static const _classId =
      "com.GitDone.gitdone.ui.task_details.task_details_view_model";

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
    create: (_) => _TaskDetailsViewViewModel(widget.task),
    child: Scaffold(
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
      floatingActionButton: Consumer<_TaskDetailsViewViewModel>(
        builder: (final context, final viewModel, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: "markTask",
              onPressed: viewModel.task.state == IssueState.open.value
                  ? viewModel._markTaskAsDone
                  : viewModel._markTaskAsOpen,
              child: viewModel.task.state == IssueState.open.value
                  ? const Icon(Icons.done)
                  : const Icon(Icons.undo),
            ),
            FloatingActionButton(
              heroTag: "editTask",
              onPressed: _editTask,
              child: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ),
  );

  Widget _renderTitle() => PageTitleWidget(title: widget.task.title);

  Widget _renderLabels() => TaskLabels(widget.task);

  Widget _renderDescription() => SingleChildScrollView(
    child: MarkdownBlock(
      data: widget.task.description,
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
        TextSpan(text: _formatDateTime(widget.task.createdAt)),
        const TextSpan(text: "\n"),
        const TextSpan(
          text: "Updated at: ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: _formatDateTime(widget.task.updatedAt)),
      ],
    ),
  );

  Future<void> _editTask() async {
    Logger.log("Edit task: ${widget.task.title}", _classId, LogLevel.detailed);
    final Task? updated = await Navigation.navigate(TaskEditView(widget.task));
    if (updated == null) {
      Logger.log("Task edit cancelled or failed", _classId, LogLevel.detailed);
      return;
    }
    setState(() {
      widget.task.replace(updated);
    });
    Logger.log(
      "Task updated: ${widget.task.title}",
      _classId,
      LogLevel.detailed,
    );
  }

  String _formatDateTime(final DateTime dateTime) =>
      DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime.toLocal());
}

class _TaskDetailsViewViewModel extends ChangeNotifier {
  _TaskDetailsViewViewModel(this._task) {
    Logger.log(
      "Initialized TaskDetailsViewModel for task: ${_task.title}",
      _classId,
      LogLevel.detailed,
    );
  }
  static const _classId =
      "com.GitDone.gitdone.ui.task_details.task_details_view_view_model";

  Task _task;

  Task get task => _task;

  Future<void> _markTaskAsDone() async {
    _task = await TaskHandler().updateIssueState(_task, IssueState.closed);
    notifyListeners();
  }

  Future<void> _markTaskAsOpen() async {
    _task = await TaskHandler().updateIssueState(_task, IssueState.open);
    notifyListeners();
  }
}
