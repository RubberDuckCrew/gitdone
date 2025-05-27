import 'package:flutter/material.dart';
import 'package:gitdone/ui/_widgets/app_bar.dart';
import 'package:gitdone/ui/home/home_screen_view_model.dart';
import 'package:gitdone/ui/home/home_view.dart';
import 'package:gitdone/ui/settings/settings_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeScreenViewModel(),
      child: Consumer<HomeScreenViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: const NormalAppBar(),
            body: switch (viewModel.selectedIndex) {
              0 => const Homeview(),
              1 => const SettingsView(),
              _ => const Homeview(),
            },
            bottomNavigationBar: NavigationBar(
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.inbox),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
              onDestinationSelected: (index) => viewModel.updateIndex(index),
              selectedIndex: viewModel.selectedIndex,
            ),
          );
        },
      ),
    );
  }
}
