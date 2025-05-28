import "package:flutter/widgets.dart";

/// The view model for the home screen, which manages the selected index
class HomeScreenViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  /// The currently selected index of the bottom navigation bar.
  int get selectedIndex => _selectedIndex;

  /// Updates the selected index of the bottom navigation bar.
  void updateIndex(final int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
