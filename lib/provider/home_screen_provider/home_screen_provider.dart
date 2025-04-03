import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// homescreen navigation index
  int _navigationIndex = 0;
  int get navigationIndex => _navigationIndex;
  set setNavigationIndex(int index) {
    _navigationIndex = index;
    notifyListeners();
  }
}
