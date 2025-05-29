import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/app_bar.dart";
import "package:gitdone/ui/home/home_screen_view_model.dart";
import "package:gitdone/ui/home/home_view.dart";
import "package:gitdone/ui/settings/settings_view.dart";
import "package:provider/provider.dart";

/// The main screen of the app, which contains the home view and settings view.
class HomeScreen extends StatefulWidget {
  /// Creates a new instance of [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
    create: (_) => HomeScreenViewModel(),
    child: Consumer<HomeScreenViewModel>(
      builder: (final context, final viewModel, final child) => Scaffold(
        appBar: const NormalAppBar(),
        body: switch (viewModel.selectedIndex) {
          0 => const HomeView(),
          1 => const SettingsView(),
          _ => const HomeView(),
        },
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.inbox), label: "Home"),
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
