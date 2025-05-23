import 'package:flutter/material.dart';

import '../../core/models/todo.dart';
import 'home_view_model.dart';

class HomeViewViewModel extends ChangeNotifier {
  final HomeViewModel _homeViewModel = HomeViewModel();
  List<Todo> get todos => _homeViewModel.todos;

  HomeViewViewModel() {
    _homeViewModel.addListener(() {
      notifyListeners();
    });
  }
}
