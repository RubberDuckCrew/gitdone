import "package:flutter/material.dart";
import "package:gitdone/core/github_api_handler.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:http/http.dart";
import "package:provider/provider.dart";

class OctoCat extends StatefulWidget {
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

class OctoCatProvider extends ChangeNotifier {
  OctoCatProvider() {
    fetchData();
  }

  Future<Response>? _futureResponse;

  Future<Response>? get futureResponse => _futureResponse;

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

  void refreshData() {
    _futureResponse = null;
    //TODO: Does this need to be called?
    notifyListeners();
    fetchData();
  }
}
