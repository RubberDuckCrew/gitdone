import 'package:flutter/material.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/ui/_widgets/octo_cat.dart';
import 'package:gitdone/ui/_widgets/todo.dart';
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Text("Filled Buttons here"),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Todo(title: "Todo 1", description: "Description of Todo 1"),
              Todo(title: "Todo 2", description: "Description of Todo 2"),
              Todo(title: "Todo 3", description: "Description of Todo 3"),
              Todo(title: "Todo 4", description: "Description of Todo 4"),
              Todo(title: "Todo 5", description: "Description of Todo 5"),
              Todo(title: "Todo 6", description: "Description of Todo 6"),
              Todo(title: "Todo 7", description: "Description of Todo 7"),
              Todo(title: "Todo 8", description: "Description of Todo 8"),
              Todo(title: "Todo 9", description: "Description of Todo 9"),
              Todo(title: "Todo 10", description: "Description of Todo 10"),
              Todo(title: "Todo 11", description: "Description of Todo 11"),
              Todo(title: "Todo 12", description: "Description of Todo 12"),
              Todo(title: "Todo 13", description: "Description of Todo 13"),
              Todo(title: "Todo 14", description: "Description of Todo 14"),
              Todo(title: "Todo 15", description: "Description of Todo 15"),
            ],
          ),
        ),
        OctoCat(),
        ElevatedButton(onPressed: logout, child: const Text("Logout")),
      ],
    );
  }
}
