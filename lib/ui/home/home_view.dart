import 'package:flutter/material.dart';
import 'package:gitdone/ui/_widgets/todo.dart';
import 'package:gitdone/ui/home/widgets/dropdown_filter_chip.dart';

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
        child: Column(
          children: [
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
                      FilterChipItem(value: "Completed", label: "Completed"),
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
                      FilterChipItem(value: "This Week", label: "This Week"),
                      FilterChipItem(value: "This Month", label: "This Month"),
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
                children: [
                  Todo(title: "Todo 1", description: "Description of Todo 1"),
                  Todo(title: "Todo 2", description: "Description of Todo 2"),
                  Todo(title: "Todo 3", description: "Description of Todo 3"),
                  Todo(title: "Todo 4", description: "Description of Todo 4"),
                  Todo(title: "Todo 5", description: "Description of Todo 5"),
                  Todo(title: "Todo 6", description: "Description of Todo 6"),
                  Todo(title: "Todo 7", description: "Description of Todo 7"),
                  Todo(title: "Todo 8", description: "Description of Todo 8"),
                  Todo(title: "Todo 9", description: "Description of Todo 9"),
                  Todo(title: "Todo 10", description: "Description of Todo 10"),
                  Todo(title: "Todo 11", description: "Description of Todo 11"),
                  Todo(title: "Todo 12", description: "Description of Todo 12"),
                  Todo(title: "Todo 13", description: "Description of Todo 13"),
                  Todo(title: "Todo 14", description: "Description of Todo 14"),
                  Todo(title: "Todo 15", description: "Description of Todo 15"),
                ],
              ),
            ),
          ],
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
