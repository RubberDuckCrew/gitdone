import 'package:flutter/material.dart';

class DeactivatableButton extends StatelessWidget {
  const DeactivatableButton({
    super.key,
    required this.child,
    required this.isDeactivated,
  });

  final MaterialButton child;
  final bool isDeactivated;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isDeactivated ? null : child.onPressed,
      onLongPress: isDeactivated ? null : child.onLongPress,
      onHighlightChanged: child.onHighlightChanged,
      textTheme: child.textTheme,
      textColor: child.textColor,
      disabledTextColor: child.disabledTextColor,
      color: child.color,
      disabledColor: child.disabledColor,
      focusColor: child.focusColor,
      hoverColor: child.hoverColor,
      highlightColor: child.highlightColor,
      splashColor: child.splashColor,
      colorBrightness: child.colorBrightness,
      elevation: child.elevation,
      focusElevation: child.focusElevation,
      hoverElevation: child.hoverElevation,
      highlightElevation: child.highlightElevation,
      disabledElevation: child.disabledElevation,
      padding: child.padding,
      visualDensity: child.visualDensity,
      shape: child.shape,
      clipBehavior: child.clipBehavior,
      focusNode: child.focusNode,
      autofocus: child.autofocus,
      materialTapTargetSize: child.materialTapTargetSize,
      animationDuration: child.animationDuration,
      minWidth: child.minWidth,
      height: child.height,
      enableFeedback: child.enableFeedback,
      child: child.child,
    );
  }
}
