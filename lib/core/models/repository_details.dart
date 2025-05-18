import 'package:github_flutter/github.dart';

class RepositoryDetails {
  final String name;
  final String owner;
  final String avatarUrl;

  RepositoryDetails({
    required this.name,
    required this.owner,
    required this.avatarUrl,
  });

  factory RepositoryDetails.fromRepository(Repository repo) {
    return RepositoryDetails(
      name: repo.name,
      owner: repo.owner!.login,
      avatarUrl: repo.owner!.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'owner': owner, 'avatarUrl': avatarUrl};
  }
}
