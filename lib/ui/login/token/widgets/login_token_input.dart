import 'package:flutter/material.dart';
import 'package:gitdone/core/github_api_handler.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/ui/home/home_screen.dart';

class LoginTokenInput extends StatefulWidget {
  const LoginTokenInput({super.key});

  @override
  State<LoginTokenInput> createState() => _LoginTokenInputState();
}

class _LoginTokenInputState extends State<LoginTokenInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'GitHub Token',
            ),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 8)),
        FilledButton(
          onPressed: login,
          child: Text("Login with Personal Access Token"),
        ),
      ],
    );
  }

  Future<void> login() async {
    if (_controller.text.isNotEmpty) {
      if (await GithubApiHandler(_controller.text).isTokenValid()) {
        TokenHandler tokenHandler = TokenHandler();
        tokenHandler.saveToken(_controller.text);
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route route) => false,
          );
        }
      } else if (mounted) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Login Failed"),
              content: Text(
                "Please verify that your access token is correct and that you have a stable internet connection, then try again.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
