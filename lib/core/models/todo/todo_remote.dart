import "package:gitdone/core/models/github_model.dart";
import "package:gitdone/core/models/todo/todo.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:github_flutter/github.dart";

//// This class represents a remote Task item in the application, extending the base [Todo] class.
class TodoRemote extends Todo {
  /// Creates a new instance of [TodoRemote].
  TodoRemote({
    required super.title,
    required super.description,
    required super.labels,
    required super.slug,
    required this.issueNumber,
    required super.createdAt,
    required super.updatedAt,
    super.closedAt,
  });

  /// Creates a to do instance from a GitHub [Issue].
  TodoRemote.fromIssue(final Issue issue, final RepositorySlug slug)
    : issueNumber = issue.number,
      super(
        title: issue.title,
        description: issue.body,
        labels: issue.labels,
        slug: slug,
        createdAt: issue.createdAt!,
        updatedAt: issue.updatedAt!,
        closedAt: issue.closedAt,
      );

  /// The unique identifier for the issue in the repository.
  final int issueNumber;

  static const _classId = "com.GitDone.gitdone.core.models.todo.todo_remote";

  @override
  Future<TodoRemote> saveRemote() async {
    Logger.logInfo("Updating issue $issueNumber", _classId);
    return (await GithubModel.github).issues
        .edit(
          slug,
          issueNumber,
          IssueRequest(
            title: title,
            body: description,
            labels: labels.map((final label) => label.name).toList(),
          ),
        )
        .then((final issue) {
          Logger.logInfo("Updated issue ${issue.number}", _classId);
          return TodoRemote.fromIssue(issue, slug);
        });
  }
}
