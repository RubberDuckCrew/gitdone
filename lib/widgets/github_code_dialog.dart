import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GithubCodeDialog extends StatefulWidget {
  final dynamic userCode;

  const GithubCodeDialog({super.key, required this.userCode});

  @override
  State<GithubCodeDialog> createState() => _GithubCodeDialogState();
}

class _GithubCodeDialogState extends State<GithubCodeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("GitHub Code"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(children: [
            Text("Please enter this code in the browser: "),
            SelectableText(
              "${widget.userCode}",
              style: TextStyle(fontSize: 20),
            ),
          ]),
          SizedBox(height: 10),
          FilledButton(
            onPressed: pressed,
            child: Text("Copy code and open browser"),
          ),
        ],
      ),
    );
  }

  void pressed() {
    Clipboard.setData(ClipboardData(text: widget.userCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Code copied to clipboard")),
    );
    Navigator.pop(context);
  }
}
