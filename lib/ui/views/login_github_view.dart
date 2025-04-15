import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gitdone/ui/view_models/login_github_view_model.dart';
import 'package:gitdone/ui/widgets/app_bar.dart';
import 'package:gitdone/ui/widgets/page_title.dart';

import 'home_view.dart';

class LoginGithubView extends StatefulWidget {
  const LoginGithubView({super.key});

  @override
  State<LoginGithubView> createState() => _LoginGithubViewState();
}

class _LoginGithubViewState extends State<LoginGithubView>
    with WidgetsBindingObserver {
  late LoginGithubViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LoginGithubViewModel(context: context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    viewModel.disposeHandler();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    developer.log("AppLifecycleState changed to: $state",
        level: 800, name: "com.GitDone.gitdone.login");
    if (state == AppLifecycleState.resumed && viewModel.inLoginProcess) {
      viewModel.continueLogin(
        onSuccess: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Homeview()),
              (Route route) => false);
        },
        onFailure: () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
          showSnackbar("Login failed. Please try again.");
        },
      );
    }
  }

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
            Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            Center(
              child: FutureBuilder(
                  future: viewModel.startLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        Text("Please enter this code in the browser: "),
                        SelectableText(
                          snapshot.data!,
                          style: TextStyle(fontSize: 20),
                        ),
                        FilledButton(
                          onPressed: () =>
                              viewModel.launchBrowser(snapshot.data!),
                          child: Text("Copy code and open browser"),
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
