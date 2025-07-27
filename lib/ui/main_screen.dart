import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/settings/settings_view.dart";
import "package:gitdone/ui/task_list/task_list_view.dart";
import "package:provider/provider.dart";

/// The main screen of the app, which contains the home view and settings view.
class MainScreen extends StatefulWidget {
  /// Creates a new instance of [MainScreen].
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
    create: (_) => MainScreenViewModel(),
    child: Consumer<MainScreenViewModel>(
      builder: (final context, final viewModel, final child) => Scaffold(
        appBar: const NormalAppBar(),
        body: switch (viewModel.selectedIndex) {
          0 => const TaskListView(),
          1 => const SettingsView(),
          _ => const TaskListView(),
        },
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.inbox), label: "Todos"),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
          onDestinationSelected: viewModel.updateIndex,
          selectedIndex: viewModel.selectedIndex,
        ),
      ),
    ),
  );
}

/// The view model for the home screen, which manages the selected index
class MainScreenViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  /// The currently selected index of the bottom navigation bar.
  int get selectedIndex => _selectedIndex;

  /// Updates the selected index of the bottom navigation bar.
  void updateIndex(final int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
