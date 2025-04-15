import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitdone/ui/widgets/app_bar.dart';
import 'package:gitdone/ui/widgets/page_title.dart';
import 'package:gitdone/utility/github_oauth_handler.dart';

import 'home_view.dart';

class LoginGithubView extends StatefulWidget {
  const LoginGithubView({super.key});

  @override
  State<LoginGithubView> createState() => _LoginGithubViewState();
}

class _LoginGithubViewState extends State<LoginGithubView>
    with WidgetsBindingObserver {
  late GitHubAuth githubAuth;

  @override
  void initState() {
    super.initState();
    githubAuth = GitHubAuth(callbackFunction: showSnackbar);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    githubAuth.resetHandler();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    developer.log("AppLifecycleState changed to: $state",
        level: 800, name: "com.GitDone.gitdone.login");
    if (state == AppLifecycleState.resumed && githubAuth.inLoginProcess) {
      continueLogin();
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
                  future: githubAuth.startLoginProcess(context),
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
                          onPressed: () => copyAndLaunch(snapshot.data!),
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

  Future<void> copyAndLaunch(String userCode) async {
    developer.log("Copying code and launching browser",
        level: 300, name: "com.GitDone.gitdone.login");
    Clipboard.setData(ClipboardData(text: userCode));
    githubAuth.launchBrowser();
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
    );
  }

  Future<void> continueLogin() async {
    var authenticated = await githubAuth.pollForToken();
    if (mounted && authenticated) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Homeview()),
          (Route route) => false);
    } else {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      showSnackbar("Login failed. Please try again.");
    }
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
