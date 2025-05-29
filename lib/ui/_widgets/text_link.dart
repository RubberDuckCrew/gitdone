import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:url_launcher/url_launcher.dart";

/// A widget that displays a clickable text link.
class TextLinkWidget {
  /// Creates an instance of [TextLinkWidget] with the given [text] and [url].
  TextLinkWidget({required final String text, required final String url})
    : _url = url,
      _text = text;
  final String _text;
  final String _url;

  /// Converts the [TextLinkWidget] to a [TextSpan] with a tap gesture recognizer.
  TextSpan toTextSpan() => TextSpan(
    text: _text,
    style: TextStyle(color: AppColor.colorScheme.secondary),
    recognizer:
        TapGestureRecognizer()
          ..onTap = () async {
            if (!await launchUrl(Uri.parse(_url))) {
              throw Exception("Could not launch $_url");
            }
          },
  );
}
