
import 'package:flutter/material.dart';

class MenuSelectionProvider with ChangeNotifier {

  int _menuIndex = 0;

  int get getMenuIndex => _menuIndex;

  int setMenuIndex(int index) {
    _menuIndex = index;
    notifyListeners();
    return _menuIndex;
  }

}