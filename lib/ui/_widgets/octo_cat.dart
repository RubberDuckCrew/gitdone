import "package:flutter/material.dart";
import "package:gitdone/core/github_api_handler.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:http/http.dart";
import "package:provider/provider.dart";

/// A widget that fetches and displays the octocat from the GitHub API.
class OctoCat extends StatefulWidget {
  /// Creates an instance of [OctoCat].
  const OctoCat({super.key});

  @override
  State<OctoCat> createState() => _OctoCatState();
}

class _OctoCatState extends State<OctoCat> {
  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
    create: (_) => OctoCatProvider(),
    child: Consumer<OctoCatProvider>(
      builder: (final context, final provider, final child) => Column(
        children: [
          FutureBuilder(
            future: provider.futureResponse,
            builder: (final context, final snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    snapshot.data!.body,
                    style: const TextStyle(
                      fontSize: 8,
                      letterSpacing: 1,
                      fontFamily: "Courier",
                    ),
                    textAlign: TextAlign.left,
                  ),
                );
              }
              return const Center(child: Text("Could not fetch octocat"));
            },
          ),
          FilledButton(
            onPressed: provider.refreshData,
            child: const Text("Fetch new octocat"),
          ),
        ],
      ),
    ),
  );
}

/// A provider that fetches and holds the octocat data.
class OctoCatProvider extends ChangeNotifier {
  /// Creates an instance of [OctoCatProvider] and fetches the octocat data.
  OctoCatProvider() {
    fetchData();
  }

  Future<Response>? _futureResponse;

  /// The future response that holds the octocat data.
  Future<Response>? get futureResponse => _futureResponse;

  /// Fetches the octocat data from the GitHub API.
  Future<Response> fetchData() async {
    if (_futureResponse == null) {
      final TokenHandler tokenHandler = TokenHandler();
      final String? token = await tokenHandler.getToken();
      if (token != null) {
        final GithubApiHandler apiHandler = GithubApiHandler(token);
        _futureResponse = apiHandler.get("/octocat");
        notifyListeners();
      } else {
        _futureResponse = Future.value(Response("No token", 401));
      }
    }
    return _futureResponse!;
  }

  /// Refreshes the octocat data by fetching it again.
  void refreshData() {
    _futureResponse = null;
    notifyListeners();
    fetchData();
  }
}
