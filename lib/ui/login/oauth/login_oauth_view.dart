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
    //context.read<LoginGithubViewModel>().startLogin();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: const NormalAppBar(),
    body: ChangeNotifierProvider(
      create: (_) {
        final viewModel = LoginGithubViewModel(
          infoCallback: (final message) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
        )..startLogin();
        return viewModel;
      },
      child: Consumer<LoginGithubViewModel>(
        builder: (final context, final viewModel, _) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
              const PageTitleWidget(title: "GitHub OAuth Login"),
              if (viewModel.errorOccurred)
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 18, height: 1.3),
                      children: [
                        const TextSpan(
                          text: "The following error occurred during login: \n",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextSpan(
                          text: viewModel.errorMessage,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!viewModel.errorOccurred)
                const Center(child: CircularProgressIndicator()),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            ],
          ),
        ),
      ),
    ),
  );
}
