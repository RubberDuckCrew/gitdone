import 'package:flutter/material.dart';
import 'package:gitdone/ui/login/oauth/login_oauth_view.dart';
import 'package:gitdone/ui/login/oauth/login_oauth_view_model.dart';
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
