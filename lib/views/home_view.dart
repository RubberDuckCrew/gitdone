import 'package:flutter/material.dart';
import 'package:gitdone/widgets/app_bar.dart';
import 'package:gitdone/widgets/octo_cat.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(),
      body: Center(
        child: Octocat(),
      ),
    );
  }
}