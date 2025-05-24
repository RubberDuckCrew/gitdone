import 'package:flutter/material.dart';
import 'package:gitdone/ui/_widgets/todo_card.dart';
import 'package:gitdone/ui/home/widgets/dropdown_filter_chip.dart';
import 'package:provider/provider.dart';

import '../../core/models/todo.dart';
import 'home_viev_view_model.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  @override
  void initState() {
    super.initState();
  }

  TodoCard convertTodoToCard(Todo todo) {
    return TodoCard(title: todo.title, description: todo.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ChangeNotifierProvider(
          create: (_) => HomeViewViewModel(),
          child: Consumer<HomeViewViewModel>(
            builder: (context, model, child) {
              return Column(
                children: [
                  FilledButton(
                    onPressed: model.loadTodos,
                    child: const Text("Get Todos"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilterChipDropdown(
                          items: [
                            FilterChipItem(value: "All", label: "All"),
                            FilterChipItem(
                              value: "Completed",
                              label: "Completed",
                            ),
                            FilterChipItem(value: "Pending", label: "Pending"),
                          ],
                          initialLabel: "Filter by",
                          allowMultipleSelection: false,
                        ),
                        const SizedBox(width: 8),
                        FilterChipDropdown(
                          items: [
                            FilterChipItem(value: "All", label: "All"),
                            FilterChipItem(value: "Today", label: "Today"),
                            FilterChipItem(
                              value: "This Week",
                              label: "This Week",
                            ),
                            FilterChipItem(
                              value: "This Month",
                              label: "This Month",
                            ),
                          ],
                          initialLabel: "Sort by",
                          allowMultipleSelection: false,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: model.todos.map(convertTodoToCard).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
