import 'package:flutter/material.dart';
import 'package:gitdone/core/theme/app_color.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
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
