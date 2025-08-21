import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/_widgets/text_link.dart";
import "package:gitdone/ui/login/token/widgets/login_token_input.dart";

/// A view for logging in with a personal access token.
class LoginTokenView extends StatefulWidget {
  /// Creates a view for logging in with a personal access token.
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18),
                    children: <TextSpan>[
                      const TextSpan(
                        text:
                            "To login via Token, "
                            "you need to generate a GitHub personal access token. "
                            "We recommend using a fine-grained personal access token, "
                            "but a classic token is also supported.\n\n",
                      ),
                      const TextSpan(
                        text: "Required Token Permissions:\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Fine-grained token
                      const TextSpan(
                        text: "\n• Fine-grained token (recommended): ",
                      ),
                      const TextSpan(
                        children: [
                          TextSpan(
                            text: "Repository: Issues, Metadata",
                            style: TextStyle(fontFamily: "monospace"),
                          ),
                          TextSpan(text: ", "),
                          TextSpan(
                            text: "Account: Profile\n",
                            style: TextStyle(fontFamily: "monospace"),
                          ),

                          TextSpan(text: "\n"),
                        ],
                      ),
                      // Classic token
                      const TextSpan(text: "• Classic token: "),
                      const TextSpan(
                        children: [
                          TextSpan(
                            text: "repo",
                            style: TextStyle(fontFamily: "monospace"),
                          ),
                          TextSpan(text: ", "),
                          TextSpan(
                            text: "read:user",
                            style: TextStyle(fontFamily: "monospace"),
                          ),
                          TextSpan(text: "\n\n"),
                        ],
                      ),
                      const TextSpan(
                        text:
                            "For more information, see the GitHub documentation.\n\n",
                      ),
                      const TextSpan(
                        text: "GitHub Documentation:\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        children: <TextSpan>[
                          TextLinkWidget(
                            text:
                                "Creating a fine-grained personal access token\n",
                            url:
                                "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/"
                                "managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token",
                          ).toTextSpan(),
                          TextLinkWidget(
                            text:
                                "Creating a personal access token (classic)\n",
                            url:
                                "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/"
                                "managing-your-personal-access-tokens#creating-a-personal-access-token-classic",
                          ).toTextSpan(),
                        ],
                      ),
                    ],
                  ),
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
