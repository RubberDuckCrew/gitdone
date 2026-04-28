import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/_widgets/page_title.dart";
import "package:gitdone/ui/_widgets/text_link.dart";
import "package:gitdone/ui/login/token/widgets/login_token_input.dart";
import "package:gitdone/ui/login/token/widgets/permission_chip.dart";

/// A view for logging in with a personal access token.
class LoginTokenView extends StatefulWidget {
  /// Creates a view for logging in with a personal access token.
  const LoginTokenView({super.key});

  @override
  State<LoginTokenView> createState() => _LoginTokenViewState();
}

class _LoginTokenViewState extends State<LoginTokenView> {
  Widget _permissionChips(final List<String> labels) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels
          .map((final label) => PermissionChip(label: label))
          .toList(),
    ),
  );

  Widget _classicToken() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Classic token:", style: TextStyle(fontSize: 18)),
      _permissionChips(["repo", "read:user"]),
    ],
  );

  Widget _personalToken() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Fine-grained token (recommended):",
        style: TextStyle(fontSize: 18),
      ),
      _permissionChips(["Repository: Issues, Metadata", "Account: Profile"]),
    ],
  );

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: const NormalAppBar(),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageTitleWidget(title: "Personal Access Token Login"),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "To login via token, "
                        "you need to generate a GitHub personal access token. "
                        "We recommend using a fine-grained personal access token, "
                        "but a classic token is also supported.",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Required Token Permissions:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _personalToken(),
                      const SizedBox(height: 16),
                      _classicToken(),
                      const SizedBox(height: 16),
                      const Text(
                        "For more information, see the GitHub documentation.",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "GitHub Documentation:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextLinkWidget(
                              text:
                                  "Creating a fine-grained personal access token",
                              url:
                                  "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/"
                                  "managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token",
                            ).toTextSpan(),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextLinkWidget(
                              text:
                                  "Creating a personal access token (classic)",
                              url:
                                  "https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/"
                                  "managing-your-personal-access-tokens#creating-a-personal-access-token-classic",
                            ).toTextSpan(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Please enter your GitHub token:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: LoginTokenInput(),
            ),
          ],
        ),
      ),
    ),
  );
}
