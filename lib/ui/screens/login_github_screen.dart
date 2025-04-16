import 'package:flutter/material.dart';
import 'package:gitdone/ui/view_models/login_github_view_model.dart';
import 'package:gitdone/ui/views/login_github_view.dart';
import 'package:provider/provider.dart';

class LoginGithubScreen extends StatelessWidget {
  const LoginGithubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginGithubViewModel(infoCallback: (text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            duration: Duration(seconds: 2),
          ),
        );
      }),
      child: const LoginGithubView(),
    );
  }
}
