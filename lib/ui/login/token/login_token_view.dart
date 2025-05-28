import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/_widgets/text_link.dart";

import "package:gitdone/ui/login/token/widgets/login_token_input.dart";

class LoginTokenView extends StatefulWidget {
  const LoginTokenView({super.key});

  @override
  State<LoginTokenView> createState() => _LoginTokenViewState();
}

class _LoginTokenViewState extends State<LoginTokenView> {
  @override
  Widget build(final BuildContext context) => Scaffold(
      appBar: const NormalAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageTitleWidget(title: "Personal Access Token Login"),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 18),
                children: <TextSpan>[
                  const TextSpan(
                    text:
                        "You need to generate a personal access token from GitHub and enter it here. You can either use an fine-grained personal access token (recommended) or a classic personal access token.\n\n",
                  ),
                  const TextSpan(
                    text: "GitHub Documentation:\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    children: <TextSpan>[
                      TextLinkWidget(
                        text: "Creating a fine-grained personal access token\n",
                        url:
                            "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token",
                      ).toTextSpan(),
                      TextLinkWidget(
                        text: "Creating a personal access token (classic)\n",
                        url:
                            "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic",
                      ).toTextSpan(),
                    ],
                  ),
                ],
              ),
            ),
            const Text(
              "Please enter your GitHub token:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            const LoginTokenInput(),
          ],
        ),
      ),
    );
}
