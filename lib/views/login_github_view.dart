import 'package:flutter/material.dart';
import 'package:gitdone/widgets/github_login_button.dart';

import '../widgets/app_bar.dart';
import '../widgets/page_title.dart';

class LoginGithubView extends StatefulWidget {
  const LoginGithubView({super.key});

  @override
  State<LoginGithubView> createState() => _LoginGithubViewState();
}

class _LoginGithubViewState extends State<LoginGithubView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageTitleWidget(
              title: "GitHub OAuth Login",
            ),
            RichText(
                text: TextSpan(
              style: TextStyle(fontSize: 18),
              text:
                  "To log in with GitHub, please copy the code below and open the browser. There authenticate with your GitHub account, paste the device code and authorize the app. After that, close the browser.",
            )),
            Text("Please enter this code in the browser: "),
            SelectableText(
              "123456",
              style: TextStyle(fontSize: 20),
            ),
            FilledButton(
              onPressed: () {},
              child: Text("Copy code and open browser"),
            ),
            Text("Temporary fallback:"),
            GithubLoginButton()
          ],
        ),
      ),
    );
  }
}
