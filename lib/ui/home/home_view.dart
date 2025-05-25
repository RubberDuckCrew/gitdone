import 'package:flutter/material.dart';
import 'package:gitdone/ui/_widgets/todo_card.dart';
import 'package:gitdone/ui/home/widgets/dropdown_filter_chip.dart';
import 'package:provider/provider.dart';

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        model.updateSearchQuery(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilterChipDropdown(
                          items: [
                            FilterChipItem(
                              value: "Completed",
                              label: "Completed",
                            ),
                            FilterChipItem(value: "Pending", label: "Pending"),
                          ],
                          initialLabel: "Filter",
                          allowMultipleSelection: false,
                          onUpdate: (value) {
                            model.updateFilter(value.value);
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChipDropdown(
                          items: [
                            FilterChipItem(
                              value: "Alphabetical",
                              label: "Alphabetical",
                            ),
                            FilterChipItem(
                              value: "Last updated",
                              label: "Last updated",
                            ),
                            FilterChipItem(value: "Created", label: "Created"),
                          ],
                          initialLabel: "Sort",
                          allowMultipleSelection: false,
                          onUpdate: (value) {
                            model.updateSort(value.value);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        model.loadTodos();
                      },
                      child: ListView(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children:
                            model.todos
                                .map((todo) => TodoCard(todo: todo))
                                .toList(),
                      ),
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
