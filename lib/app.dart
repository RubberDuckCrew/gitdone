import 'package:flutter/material.dart';
import 'package:gitdone/scheme/app_color.dart';
import 'package:gitdone/ui/views/home_view.dart';
import 'package:gitdone/ui/views/welcome_view.dart';
import 'package:gitdone/utility/token_handler.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: AppColor.colorScheme,
          useMaterial3: true,
        ),
        home: FutureBuilder(
            future: checkIfAuthenticated(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasData && snapshot.data == true) {
                return Homeview();
              } else {
                return WelcomeView();
              }
            }));
  }

  Future<bool> checkIfAuthenticated() async {
    TokenHandler tokenHandler = TokenHandler();
    return await tokenHandler.getToken() != null;
  }
}
