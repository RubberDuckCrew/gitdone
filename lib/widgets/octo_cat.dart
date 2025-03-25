import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../utility/github_api_handler.dart';
import '../utility/token_handler.dart';

class OctoCat extends StatefulWidget {
  const OctoCat({super.key});

  @override
  State<OctoCat> createState() => _OctoCatState();
}

class _OctoCatState extends State<OctoCat> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: _fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text.rich(
                      TextSpan(
                          text: snapshot.data!.body.toString(),
                          style: TextStyle(
                              fontSize: 8,
                              letterSpacing: 1,
                              fontFamily: "Courier")),
                      textAlign: TextAlign.left,
                    ));
              }
              return const Center(child: Text("Could not fetch octocat"));
            }),
        ElevatedButton(
          onPressed: () {
            setState(() {});
          },
          child: Text("Fetch new octocat"),
        )
      ],
    );
  }

  Future<Response> _fetchData() async {
    TokenHandler tokenHandler = TokenHandler();
    String? token = await tokenHandler.getToken();
    if (token != null) {
      GithubApiHandler apiHandler = GithubApiHandler(token);
      return await apiHandler.get('/octocat');
    }
    return Response('No token', 401);
  }
}
