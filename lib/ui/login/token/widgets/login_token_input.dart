import "package:flutter/material.dart";
import "package:gitdone/core/github_api_handler.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/main_screen.dart";

/// A widget that provides an input field for the user to enter their GitHub
class LoginTokenInput extends StatefulWidget {
  /// Creates an instance of [LoginTokenInput].
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
        TokenHandler().saveToken(_controller.text);
        if (mounted) {
          Navigation.navigateClean(const MainScreen());
        }
      } else if (mounted) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Text("Login Failed"),
            content: Text(
              "Please verify that your access token is correct and that you have a stable internet connection, then try again.",
            ),
            actions: [
              TextButton(onPressed: Navigation.navigateBack, child: Text("OK")),
            ],
          ),
        );
      }
    }
  }
}
