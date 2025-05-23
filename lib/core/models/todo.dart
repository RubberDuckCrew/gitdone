import 'package:github_flutter/github.dart';

class Todo {
  final String title;
  final String description;

  Todo({required this.title, required this.description});

  @override
  String toString() {
    return 'Todo{title: $title, description: $description}';
  }

  static Todo fromIssue(Issue issue) {
    return Todo(title: issue.title, description: issue.body);
  }
}
