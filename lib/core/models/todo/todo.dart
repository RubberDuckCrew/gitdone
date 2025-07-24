import "package:gitdone/core/models/github_model.dart";
import "package:gitdone/core/models/todo/todo_remote.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";

/// This class represents a Task item in the application.
class Todo {
  /// Creates a instance with the given parameters.
  Todo({
    required this.title,
    required this.description,
    required this.labels,
    required final slug,
    required this.createdAt,
    required this.updatedAt,
    this.closedAt,
  }) : _slug = slug;

  /// Creates an empty to do instance with the given slug and issue number.
  Todo.createEmpty({required final RepositorySlug slug})
    : title = "",
      description = "",
      _slug = slug,
      createdAt = DateTime.now(),
      updatedAt = DateTime.now();

  static const _classId = "com.GitDone.gitdone.core.models.todo.todo";

  /// The title of the task.
  String title;

  /// The description of the task.
  String description;

  /// The labels associated with the task.
  List<IssueLabel> labels = <IssueLabel>[];

  /// The date and time when the issue was created.
  final DateTime createdAt;

  /// The date and time when the issue was last updated.
  DateTime updatedAt;

  /// The date and time when the issue was closed, if applicable.
  DateTime? closedAt;

  /// Gets the [RepositorySlug] of the task.
  RepositorySlug get slug => _slug;
  final RepositorySlug _slug;

  /// Saves the current task to the remote repository.
  Future<TodoRemote> saveRemote() async {
    Logger.logInfo("Creating issue in $slug", _classId);
    return (await GithubModel.github).issues
        .create(
          slug,
          IssueRequest(
            title: title,
            body: description,
            labels: labels.map((final label) => label.name).toList(),
          ),
        )
        .then((final issue) {
          Logger.logInfo("Created issue ${issue.number}", _classId);
          return TodoRemote.fromIssue(issue, slug);
        });
  }

  /// Creates a copy of the current instance.
  Todo copy() => Todo(
    title: title,
    description: description,
    labels: List<IssueLabel>.from(labels),
    createdAt: createdAt,
    updatedAt: updatedAt,
    closedAt: closedAt,
    slug: _slug,
  );

  /// Replaces the current instance with the values from another to do instance.
  void replace(final Todo update) {
    title = update.title;
    description = update.description;
    labels = List<IssueLabel>.from(update.labels);
    updatedAt = update.updatedAt;
    closedAt = update.closedAt;
  }

  @override
  String toString() =>
      "Todo(title: $title, description: ${description.replaceAll("\n", r"\n")}, labels: $labels, slug: $_slug, createdAt: $createdAt, updatedAt: $updatedAt, closedAt: $closedAt)";
}
