import 'package:flutter/material.dart';
import 'package:gitdone/app.dart';
import 'package:provider/provider.dart';

void main() {
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  runApp(
    Provider<String>.value(
      value:
          flavor, // Get flavor anywhere with final flavor = Provider.of<String>(context);
      child: const App(),
    ),
  );
}
