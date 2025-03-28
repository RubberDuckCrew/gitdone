import 'package:flutter/material.dart';

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
            obscureText: true,
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

  void login() {
    if (_controller.text.isNotEmpty) {
      TokenHandler tokenHandler = TokenHandler();
      tokenHandler.saveToken(_controller.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homeview()));
    }
  }
}
