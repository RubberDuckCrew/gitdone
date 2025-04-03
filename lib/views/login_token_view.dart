import 'package:flutter/material.dart';
import 'package:gitdone/widgets/text_link.dart';

import '../widgets/app_bar.dart';
import '../widgets/login_toke_input.dart';
import '../widgets/page_title.dart';

class LoginTokenView extends StatefulWidget {
  const LoginTokenView({super.key});

  @override
  State<LoginTokenView> createState() => _LoginTokenViewState();
}

class _LoginTokenViewState extends State<LoginTokenView> {
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
              title: "Personal Access Token Login",
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 18),
                    children: <TextSpan>[
                  TextSpan(
                      text:
                          "You need to generate a personal access token from GitHub and enter it here. You can either use an fine-grained personal access token (recommended) or a classic personal access token.\n\n"),
                  TextSpan(
                      text: "GitHub Documentation:\n",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(children: <TextSpan>[
                    TextLinkWidget(
                            text:
                                "Creating a fine-grained personal access token\n",
                            url:
                                "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token")
                        .toTextSpan(),
                    TextLinkWidget(
                            text:
                                "Creating a personal access token (classic)\n",
                            url:
                                "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic")
                        .toTextSpan()
                  ])
                ])),
            Text("Please enter your GitHub token:",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            LoginTokenInput(),
          ],
        ),
      ),
    );
  }
}
