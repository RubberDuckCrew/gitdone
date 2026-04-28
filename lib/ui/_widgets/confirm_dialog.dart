import "package:flutter/material.dart";
import "package:gitdone/core/utils/navigation.dart";

/// A dialog that asks the user to confirm an action.
class ConfirmDialog extends StatelessWidget {
  /// Creates a [ConfirmDialog] widget with the given parameters.
  const ConfirmDialog({
    required final Widget title,
    required final Widget content,
    required final String confirmText,
    required final VoidCallback onConfirm,
    required final String cancelText,
    final VoidCallback? onCancel,
    super.key,
  }) : _title = title,
       _content = content,
       _confirmText = confirmText,
       _cancelText = cancelText,
       _onConfirm = onConfirm,
       _onCancel = onCancel;

  final Widget _title;
  final Widget _content;
  final String _confirmText;
  final String _cancelText;
  final VoidCallback _onConfirm;
  final VoidCallback? _onCancel;

  @override
  Widget build(final BuildContext context) => AlertDialog(
    title: _title,
    content: _content,
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigation.navigateBack();
          _onConfirm();
        },
        child: Text(_confirmText),
      ),
      TextButton(
        onPressed: () {
          Navigation.navigateBack();
          if (_onCancel != null) _onCancel();
        },
        child: Text(_cancelText),
      ),
    ],
  );

  /// Shows the ConfirmDialog as a dialog.
  static Future<void> show(
    final BuildContext context, {
    required final Widget title,
    required final Widget content,
    required final String confirmText,
    required final VoidCallback onConfirm,
    final String cancelText = "Cancel",
    final VoidCallback? onCancel,
    final bool barrierDismissible = true,
  }) => showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (final context) => ConfirmDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );
}
