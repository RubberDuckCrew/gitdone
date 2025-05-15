import 'package:flutter/material.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:gitdone/core/theme/app_color.dart';
import 'package:gitdone/ui/home/home_screen.dart';
import 'package:gitdone/ui/welcome/welcome_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: AppColor.colorScheme, useMaterial3: true),
      home: FutureBuilder(
        future: checkIfAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen();
          } else {
            return WelcomeView();
          }
        },
      ),
    );
  }

  Future<bool> checkIfAuthenticated() async {
    TokenHandler tokenHandler = TokenHandler();
    return await tokenHandler.getToken() != null;
  }
}
