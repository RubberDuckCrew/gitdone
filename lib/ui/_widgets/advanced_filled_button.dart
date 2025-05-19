import 'package:flutter/material.dart';

class AdvancedFilledButton extends StatefulWidget {
  const AdvancedFilledButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.enabled,
  });

  final Widget child;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  State<AdvancedFilledButton> createState() => _AdvancedFilledButtonState();
}

class _AdvancedFilledButtonState extends State<AdvancedFilledButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: widget.enabled ? widget.onPressed : null,
      style:
          !widget.enabled
              ? ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
              )
              : null,
      child: widget.child,
    );
  }
}
