import 'package:flutter/material.dart';
import 'package:gitdone/scheme/AppColors.dart';
import 'package:gitdone/utility/TokenHandler.dart';
import 'package:gitdone/views/HomeView.dart';
import 'package:gitdone/views/loginView.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: AppColors.colorScheme,
          useMaterial3: true,
        ),
        home: FutureBuilder(
            future: checkIfAuthenticated(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(
                        child: CircularProgressIndicator()));
              }
              if (snapshot.hasData && snapshot.data == true) {
                return Homeview();
              } else {
                return LoginView();
              }
            }));
  }

  Future<bool> checkIfAuthenticated() async {
    TokenHandler tokenHandler = TokenHandler();
    return await tokenHandler.getToken() != null;
  }
}
