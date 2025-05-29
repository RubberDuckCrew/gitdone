import "package:github_flutter/github.dart";

/// This class represents the details of a GitHub repository.
class RepositoryDetails {
  /// Creates a [RepositoryDetails] instance with the given parameters.
  RepositoryDetails({
    required this.name,
    required this.owner,
    required this.avatarUrl,
  });

  /// Creates a [RepositoryDetails] instance from a JSON map.
  factory RepositoryDetails.fromJson(final Map<String, dynamic> json) =>
      RepositoryDetails(
        name: json["name"] as String,
        owner: json["owner"] as String,
        avatarUrl: json["avatarUrl"] as String,
      );

  /// Creates a [RepositoryDetails] instance from a [Repository] object.
  factory RepositoryDetails.fromRepository(final Repository repo) =>
      RepositoryDetails(
        name: repo.name,
        owner: repo.owner!.login,
        avatarUrl: repo.owner!.avatarUrl,
      );

  /// The name of the repository.
  final String name;

  /// The owner of the repository.
  final String owner;

  /// The avatar URL of the repository owner.
  final String avatarUrl;

  /// Converts the [RepositoryDetails] instance to a JSON map.
  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "avatarUrl": avatarUrl,
  };

  RepositorySlug toSlug() => RepositorySlug(owner, name);
}
