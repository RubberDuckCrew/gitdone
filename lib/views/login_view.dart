import 'package:flutter/material.dart';
import 'package:gitdone/widgets/github_login_button.dart';
import 'package:gitdone/widgets/github_token_input.dart';
import 'package:gitdone/widgets/title.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Spacer(
            flex: 2,
          ),
          const TitleWidget(),
          const Spacer(
            flex: 1,
          ),
          const GithubLoginButton(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FilledButton(
                onPressed: openLoginBottomSheet,
                child: const Text("Login with Personal Access Token")),
          ),
          const Spacer(
            flex: 1,
          ),
        ],
      ),
    ));
  }

  void openLoginBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      scrollControlDisabledMaxHeightRatio: 0.5,
      context: context,
      builder: (context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                Expanded(child: TitleWidget()),
                Expanded(
                  flex: 2,
                  child: GithubTokenInput(),
                ),
                Spacer(
                  flex: 2,
                )
              ],
            ));
      },
    );
  }
}
