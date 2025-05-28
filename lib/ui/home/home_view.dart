import "package:flutter/material.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:gitdone/ui/_widgets/octo_cat.dart";
import "package:gitdone/ui/welcome/welcome_view.dart";

/// The home view of the app, which is displayed after login.
class HomeView extends StatefulWidget {
  /// Creates a new instance of [HomeView].
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> logout() async {
    final TokenHandler tokenHandler = TokenHandler();
    await tokenHandler.deleteToken();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (final context) => const WelcomeView()),
    );
  }

  @override
  Widget build(final BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const OctoCat(),
        ElevatedButton(onPressed: logout, child: const Text("Logout")),
      ],
    ),
  );
}
