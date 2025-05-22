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

  static RepositoryDetails fromJson(Map<String, dynamic> json) {
    return RepositoryDetails(
      name: json['name'] as String,
      owner: json['owner'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );
  }
}
