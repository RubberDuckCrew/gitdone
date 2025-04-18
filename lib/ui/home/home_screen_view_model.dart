import 'package:flutter/widgets.dart';

class HomeScreenViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
