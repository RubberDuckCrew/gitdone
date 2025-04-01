import 'package:flutter/material.dart';
import 'package:gitdone/utility/github_api_handler.dart';

import '../utility/token_handler.dart';
import '../views/home_view.dart';

class GithubTokenInput extends StatefulWidget {
  const GithubTokenInput({super.key});

  @override
  State<GithubTokenInput> createState() => _GithubTokenInputState();
}

class _GithubTokenInputState extends State<GithubTokenInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Spacer(),
        Text(
          "Please enter your GitHub token:",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'GitHub Token',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: FilledButton(
            onPressed: login,
            child: Text("Login with Personal Access Token"),
          ),
        ),
        Spacer(
          flex: 2,
        )
      ],
    );
  }

  Future<void> login() async {
    if (_controller.text.isNotEmpty) {
      if (await GithubApiHandler(_controller.text).isTokenValid()) {
        TokenHandler tokenHandler = TokenHandler();
        tokenHandler.saveToken(_controller.text);
        if (mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homeview()));
        }
      } else if (mounted) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Could not login"),
                content: Text(
                    "Please ensure that your access token is correct and that you have an active internet connection. Try again."),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: Text("OK"),
                  ),
                ],
              );
            });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid token. Please try again."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
