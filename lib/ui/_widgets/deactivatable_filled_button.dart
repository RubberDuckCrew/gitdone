import 'package:flutter/material.dart';

class DeactivatableFilledButton extends StatefulWidget {
  const DeactivatableFilledButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.enabled,
  });

  final Widget child;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  State<DeactivatableFilledButton> createState() =>
      _DeactivatableFilledButtonState();
}

class _DeactivatableFilledButtonState extends State<DeactivatableFilledButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: widget.enabled ? widget.onPressed : null,
      style:
          !widget.enabled
              ? ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey),
              )
              : null,
      child: widget.child,
    );
  }
}
