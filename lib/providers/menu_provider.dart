
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {

  int _currentPage = 0;

  int get getCurrentPage => _currentPage;

  int setMenuIndex(int index) {
    _currentPage = index;
    notifyListeners();
    return _currentPage;
  }

}