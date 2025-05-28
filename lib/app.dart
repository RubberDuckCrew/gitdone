import "package:flutter/material.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:gitdone/ui/home/home_screen.dart";
import "package:gitdone/ui/welcome/welcome_view.dart";

/// The main entry point of the GitDone application.
class App extends StatelessWidget {
  /// Creates an instance of the [App] widget.
  const App({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
      theme: ThemeData(colorScheme: AppColor.colorScheme, useMaterial3: true),
      home: FutureBuilder(
        future: checkIfAuthenticated(),
        builder: (final context, final snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          } else {
            return const WelcomeView();
          }
        },
      ),
    );

  /// Checks if the user is authenticated by verifying the presence of a token.
  Future<bool> checkIfAuthenticated() async {
    final TokenHandler tokenHandler = TokenHandler();
    return await tokenHandler.getToken() != null;
  }
}
