import 'package:flutter/material.dart';
import 'package:gitdone/utility/TokenHandler.dart';
import 'package:gitdone/views/HomeView.dart';
import 'package:gitdone/widgets/Appbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(),
        body: Center(
      child: Column(
        children: [
          const Spacer(),
          const Text("Please enter your GitHub token:", style: TextStyle(fontSize: 20),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(onPressed: login, child: const Text("Login")),
          ),
          const Spacer()
        ],
      ),
    ));
  }

  void login() {
    if (_controller.text.isNotEmpty) {
      TokenHandler tokenHandler = TokenHandler();
      tokenHandler.saveToken(_controller.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Homeview()));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a token")));
    }
  }
}
