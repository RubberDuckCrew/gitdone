import 'package:flutter/material.dart';
import 'package:gitdone/widgets/Appbar.dart';
import 'package:gitdone/utility/GithubApiHandler.dart';
import 'package:gitdone/utility/TokenHandler.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  String _response = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    TokenHandler tokenHandler = TokenHandler();
    String? token = await tokenHandler.getToken();
    if (token != null) {
      GithubApiHandler apiHandler = GithubApiHandler(token);
      final response = await apiHandler.get('/octocat');
      setState(() {
        _response = response.body;
      });
    } else {
      setState(() {
        _response = "Token not found";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(),
      body: Center(
        child: Text(_response, style: TextStyle(fontSize: 8),),
      ),
    );
  }
}