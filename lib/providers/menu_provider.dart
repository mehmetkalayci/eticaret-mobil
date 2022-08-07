
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {

  int _currentPage = 0;
  int get getCurrentPage => _currentPage;

  int _categoryId = 0;
  int get getCategoryId => _categoryId;

  int _productId = 0;
  int get getProductId => _productId;

  int setMenuIndex(int index, {int productId=0, int categoryId=0}) {
    _currentPage = index;
    _productId = productId;
    _categoryId = categoryId;
    notifyListeners();
    return _currentPage;
  }

}