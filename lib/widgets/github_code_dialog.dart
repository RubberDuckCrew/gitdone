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
          Text("Bitte diesen Code eingeben: ${widget.userCode}"),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: pressed,
            child: Text("Code kopieren"),
          ),
        ],
      ),
    );
  }

  void pressed() {
    Clipboard.setData(ClipboardData(text: widget.userCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Code in die Zwischenablage kopiert")),
    );
    Navigator.pop(context);
  }
}
