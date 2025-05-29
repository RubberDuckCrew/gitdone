import "package:github_flutter/github.dart";

class Todo {
  Todo({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.labels,
    this.updatedAt,
    this.closedAt,
  });
  String title;
  String description;
  List<IssueLabel> labels = <IssueLabel>[];
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? closedAt;

  @override
  String toString() =>
      "Todo(title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, closedAt: $closedAt, labels: $labels)";

  static Todo fromIssue(final Issue issue) => Todo(
    title: issue.title,
    description: issue.body,
    createdAt: issue.createdAt!,
    updatedAt: issue.updatedAt,
    closedAt: issue.closedAt,
    labels: issue.labels,
  );
}
