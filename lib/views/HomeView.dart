import 'package:flutter/material.dart';
import 'package:gitdone/widgets/Appbar.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(),
      body: Center(
        child: Text("Welcome to GitDone"),
      ),
    );
  }
}
