import "package:gitdone/core/models/github_model.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";

/// This class represents a Task item in the application.
class Task {
  /// Creates a instance with the given parameters.
  Task({
    required this.title,
    required this.description,
    required this.labels,
    required final slug,
    required this.createdAt,
    required this.updatedAt,
    this.state = "open",
    this.closedAt,
    this.stateReason,
    final issueNumber,
  }) : _slug = slug,
       _issueNumber = issueNumber;

  /// Creates a to do instance from a GitHub [Issue].
  Task.fromIssue(final Issue issue, this._slug)
    : title = issue.title,
      description = issue.body,
      createdAt = issue.createdAt!,
      updatedAt = issue.updatedAt!,
      closedAt = issue.closedAt,
      labels = issue.labels,
      _issueNumber = issue.number,
      state = issue.state,
      stateReason = issue.stateReason;

  /// Creates an empty task with the given [slug].
  Task.createEmpty(final RepositorySlug slug)
    : title = "",
      description = "",
      labels = <IssueLabel>[],
      createdAt = DateTime.now(),
      updatedAt = DateTime.now(),
      closedAt = null,
      _slug = slug,
      _issueNumber = null,
      state = "open";

  static const _classId = "com.GitDone.gitdone.core.models.task";

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

  /// The unique identifier for the issue in the repository, if applicable.
  int? get issueNumber => _issueNumber;
  final int? _issueNumber;

  /// The state of the task, e.g., "OPEN" or "CLOSED".
  String state;

  /// The reason for the current state of the task, if applicable.
  String? stateReason;

  /// Saves the current task to the remote repository.
  Future<Task> saveRemote() {
    if (_issueNumber == null) {
      Logger.logInfo("Creating issue in $slug", _classId);
      return _createRemote();
    } else {
      Logger.logInfo("Updating issue $issueNumber", _classId);
      return _updateRemote();
    }
  }

  Future<Task> _createRemote() async => (await GithubModel.github).issues
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
        return Task.fromIssue(issue, slug);
      });

  Future<Task> _updateRemote() async => (await GithubModel.github).issues
      .edit(
        slug,
        _issueNumber!,
        IssueRequest(
          title: title,
          body: description,
          labels: labels.map((final label) => label.name).toList(),
        ),
      )
      .then((final issue) {
        Logger.logInfo("Updated issue ${issue.number}", _classId);
        return Task.fromIssue(issue, slug);
      });

  /// Creates a copy of the current instance.
  Task copy() => Task(
    title: title,
    description: description,
    labels: List<IssueLabel>.from(labels),
    createdAt: createdAt,
    updatedAt: updatedAt,
    closedAt: closedAt,
    slug: _slug,
    issueNumber: _issueNumber,
  );

  /// Replaces the current instance with the values from another to do instance.
  void replace(final Task update) {
    title = update.title;
    description = update.description;
    labels = List<IssueLabel>.from(update.labels);
    updatedAt = update.updatedAt;
    closedAt = update.closedAt;
  }

  @override
  String toString() =>
      "Todo(title: $title, description: ${description.replaceAll("\n", r"\n")}, labels: $labels, createdAt: $createdAt, updatedAt: $updatedAt, closedAt: $closedAt, slug: $_slug, issueNumber: $_issueNumber)";
}
