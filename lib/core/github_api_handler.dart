import "dart:developer" as developer;

import "package:http/http.dart" as http;

/// A handler for making requests to the GitHub API.
class GithubApiHandler {
  /// Creates a new instance of [GithubApiHandler] with the provided [token].
  GithubApiHandler(this._token);

  final _baseUrl = "https://api.github.com";
  final String _token;

  /// Makes a GET request to the GitHub API at the specified [path].
  Future<http.Response> get(final String path) => http.get(
    Uri.parse("$_baseUrl$path"),
    headers: {"Authorization": "Bearer $_token"},
  );

  /// Makes a POST request to the GitHub API at the specified [path] with
  /// the provided [body].
  Future<http.Response> post(final String path, {required final String body}) =>
      http.post(
        Uri.parse("$_baseUrl$path"),
        headers: {"Authorization": "Bearer $_token"},
        body: body,
      );

  /// Makes a PATCH request to the GitHub API at the specified [path] with the
  /// provided [body].
  Future<http.Response> patch(
    final String path, {
    required final String body,
  }) => http.patch(
    Uri.parse("$_baseUrl$path"),
    headers: {"Authorization": "Bearer $_token"},
    body: body,
  );

  /// Makes a DELETE request to the GitHub API at the specified [path].
  Future<http.Response> delete(final String path) => http.delete(
    Uri.parse("$_baseUrl$path"),
    headers: {"Authorization": "Bearer $_token"},
  );

  /// Checks if the provided token is valid by making a request to the
  /// `/user` endpoint.
  Future<bool> isTokenValid() async {
    developer.log(
      "Checking token validity",
      name: "com.GitDone.gitdone.github_api_handler",
    );
    final http.Response response = await get("/user");
    return response.statusCode == 200;
  }
}
