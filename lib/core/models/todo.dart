import "package:github_flutter/github.dart";

/// This class represents a Task item in the application.
class Todo {
  /// Creates a instance with the given parameters.
  Todo({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.labels,
    this.updatedAt,
    this.closedAt,
  });

  /// Converts the instance to a JSON map.
  Todo.fromIssue(final Issue issue)
    : title = issue.title,
      description = issue.body,
      createdAt = issue.createdAt!,
      updatedAt = issue.updatedAt,
      closedAt = issue.closedAt,
      labels = issue.labels;

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

  @override
  String toString() =>
      "Todo(title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, closedAt: $closedAt, labels: $labels)";
}
