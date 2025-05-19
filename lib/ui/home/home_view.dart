import 'package:flutter/material.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/ui/_widgets/octo_cat.dart';
import 'package:gitdone/ui/welcome/welcome_view.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  @override
  void initState() {
    super.initState();
  }

  void logout() async {
    TokenHandler tokenHandler = TokenHandler();
    await tokenHandler.deleteToken();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OctoCat(),
          ElevatedButton(onPressed: logout, child: const Text("Logout")),
        ],
      ),
    );
  }
}
