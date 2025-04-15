import 'package:flutter/material.dart';
import 'package:gitdone/utility/github_api_handler.dart';
import 'package:gitdone/utility/token_handler.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class OctoCat extends StatefulWidget {
  const OctoCat({super.key});

  @override
  State<OctoCat> createState() => _OctoCatState();
}

class _OctoCatState extends State<OctoCat> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => OctoCatProvider(),
        child: Consumer<OctoCatProvider>(builder: (context, provider, child) {
          return Column(
            children: [
              FutureBuilder(
                  future: provider.futureResponse,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      return FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            snapshot.data!.body.toString(),
                            style: TextStyle(
                                fontSize: 8,
                                letterSpacing: 1,
                                fontFamily: "Courier"),
                            textAlign: TextAlign.left,
                          ));
                    }
                    return const Center(child: Text("Could not fetch octocat"));
                  }),
              FilledButton(
                onPressed: () {
                  provider.refreshData();
                },
                child: Text("Fetch new octocat"),
              ),
            ],
          );
        }));
  }
}

class OctoCatProvider extends ChangeNotifier {
  OctoCatProvider() {
    fetchData();
  }

  Future<Response>? _futureResponse;

  Future<Response>? get futureResponse => _futureResponse;

  Future<Response> fetchData() async {
    if (_futureResponse == null) {
      TokenHandler tokenHandler = TokenHandler();
      String? token = await tokenHandler.getToken();
      if (token != null) {
        GithubApiHandler apiHandler = GithubApiHandler(token);
        _futureResponse = apiHandler.get('/octocat');
        notifyListeners();
      } else {
        _futureResponse = Future.value(Response('No token', 401));
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
