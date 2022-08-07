import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {

  int _currentPage = 0;
  int _categoryId = 0;
  int _subCategoryId = 0;
  int _productId = 0;

  int get currentPage => _currentPage;

  setCurrentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  int get categoryId => _categoryId;

  setCategoryId(int value) {
    _categoryId = value;
    notifyListeners();
  }

  int get SubCategoryId => _subCategoryId;

  setSubCategoryId(int value) {
    _subCategoryId = value;
    notifyListeners();
  }

  int get productId => _productId;

  setProductId(int value) {
    _productId = value;
    notifyListeners();
  }

}
