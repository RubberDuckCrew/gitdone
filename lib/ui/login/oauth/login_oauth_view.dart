import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/login/oauth/login_oauth_view_model.dart";
import "package:provider/provider.dart";

/// A view for logging in with GitHub OAuth.
class LoginGithubView extends StatefulWidget {
  /// Creates a view for logging in with GitHub OAuth.
  const LoginGithubView({super.key});

  @override
  State<LoginGithubView> createState() => _LoginGithubViewState();
}

class _LoginGithubViewState extends State<LoginGithubView> {
  @override
  void initState() {
    super.initState();
    context.read<LoginGithubViewModel>().startLogin();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: const NormalAppBar(),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
          const PageTitleWidget(title: "GitHub OAuth Login"),
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 18, height: 1.3),
                children: [
                  TextSpan(
                    text:
                        "To log in with GitHub, please follow these steps:\n\n",
                  ),
                  TextSpan(
                    text: "1. Copy the code below to open the browser\n",
                  ),
                  TextSpan(text: "2. Log in with your GitHub account\n"),
                  TextSpan(
                    text: "3. Paste the device code and authorize the app\n",
                  ),
                  TextSpan(text: "4. Close the browser\n"),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
        ],
      ),
    ),
  );
}
