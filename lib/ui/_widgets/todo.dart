import 'package:flutter/material.dart';
import 'package:gitdone/core/theme/app_color.dart';

class Todo extends StatefulWidget {
  const Todo({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Placeholder(fallbackHeight: 50, fallbackWidth: 50),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColor.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
