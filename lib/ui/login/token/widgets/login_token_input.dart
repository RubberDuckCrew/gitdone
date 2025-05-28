import "package:flutter/material.dart";
import "package:gitdone/core/github_api_handler.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:gitdone/ui/home/home_screen.dart";

class LoginTokenInput extends StatefulWidget {
  const LoginTokenInput({super.key});

  @override
  State<LoginTokenInput> createState() => _LoginTokenInputState();
}

class _LoginTokenInputState extends State<LoginTokenInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(final BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "GitHub Token",
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
      FilledButton(
        onPressed: login,
        child: const Text("Login with Personal Access Token"),
      ),
    ],
  );

  Future<void> login() async {
    if (_controller.text.isNotEmpty) {
      if (await GithubApiHandler(_controller.text).isTokenValid()) {
        final TokenHandler tokenHandler = TokenHandler();
        tokenHandler.saveToken(_controller.text);
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (final context) => const HomeScreen()),
            (final route) => false,
          );
        }
      } else if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text(
              "Please verify that your access token is correct and that you have a stable internet connection, then try again.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }
}
