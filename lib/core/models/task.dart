import "package:gitdone/core/models/github_model.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";

/// This class represents a Task item in the application.
class Task {
  /// Creates a instance with the given parameters.
  Task({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.labels,
    required final slug,
    required final issueNumber,
    this.updatedAt,
    this.closedAt,
  }) : _slug = slug,
       _issueNumber = issueNumber;

  /// Creates a to do instance from a GitHub [Issue].
  Task.fromIssue(final Issue issue, this._slug)
    : title = issue.title,
      description = issue.body,
      createdAt = issue.createdAt!,
      updatedAt = issue.updatedAt,
      closedAt = issue.closedAt,
      labels = issue.labels,
      _issueNumber = issue.number;

  static const _classId = "com.GitDone.gitdone.core.models.task";

  /// The title of the task.
  String title;

  /// The description of the task.
  String description;

  /// The labels associated with the task.
  List<IssueLabel> labels = <IssueLabel>[];

  /// The date and time when the task was created.
  DateTime createdAt;

  /// The date and time when the task was last updated.
  DateTime? updatedAt;

  /// The date and time when the task was closed.
  DateTime? closedAt;

  final RepositorySlug _slug;
  final int _issueNumber;

  /// Updates the remote issue on GitHub with the current to do details.
  Future<void> updateRemote() async {
    Logger.logInfo("Updating issue $_issueNumber", _classId);
    (await GithubModel.github).issues
        .edit(
          _slug,
          _issueNumber,
          IssueRequest(
            title: title,
            body: description,
            labels: labels.map((final label) => label.name).toList(),
          ),
        )
        .then((final issue) {
          updatedAt = issue.updatedAt;
          closedAt = issue.closedAt;
          Logger.logInfo("Updated issue ${issue.number}", _classId);
        });
  }

  /// Creates a copy of the current instance.
  Task copy() => Task(
    title: title,
    description: description,
    createdAt: createdAt,
    updatedAt: updatedAt,
    closedAt: closedAt,
    labels: List<IssueLabel>.from(labels),
    slug: _slug,
    issueNumber: _issueNumber,
  );

  /// Replaces the current instance with the values from another to do instance.
  void replace(final Task update) {
    title = update.title;
    description = update.description;
    createdAt = update.createdAt;
    updatedAt = update.updatedAt;
    closedAt = update.closedAt;
    labels = List<IssueLabel>.from(update.labels);
  }

  @override
  String toString() =>
      "Task(title: $title, description: ${description.replaceAll("\n", r"\n")}, createdAt: $createdAt, updatedAt: $updatedAt, closedAt: $closedAt, labels: $labels)";
}
