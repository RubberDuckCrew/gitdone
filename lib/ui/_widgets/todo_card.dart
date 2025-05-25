import 'package:flutter/material.dart';
import 'package:gitdone/core/theme/app_color.dart';

import '../../core/models/todo.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({super.key, required this.todo});

  final Todo todo;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: AppColor.colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Placeholder(fallbackHeight: 50, fallbackWidth: 50),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.todo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColor.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children:
                          widget.todo.labels
                              .map(
                                (label) => Chip(
                                  label: Text(label.name),
                                  backgroundColor:
                                      AppColor.colorScheme.surfaceContainer,
                                  labelStyle: TextStyle(
                                    color: AppColor.colorScheme.onSurface,
                                    fontSize: 12,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 0,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
