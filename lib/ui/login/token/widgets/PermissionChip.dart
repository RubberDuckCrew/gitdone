import "package:flutter/material.dart";

class PermissionChip extends StatelessWidget {
  const PermissionChip({required this.label});

  /**
   * The label of the permission chip.
   */
  final String label;

  @override
  Widget build(final BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey.shade800,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade800),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontFamily: "monospace",
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
