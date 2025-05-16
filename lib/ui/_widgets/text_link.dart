import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gitdone/core/theme/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class TextLinkWidget {
  final String text;
  final String url;

  TextLinkWidget({required this.text, required this.url});

  TextSpan toTextSpan() {
    return TextSpan(
      text: text,
      style: TextStyle(color: AppColor.colorScheme.secondary),
      recognizer:
          TapGestureRecognizer()
            ..onTap = () async {
              if (!await launchUrl(Uri.parse(url))) {
                throw 'Could not launch $url';
              }
            },
    );
  }
}
