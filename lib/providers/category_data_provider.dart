import 'dart:convert';

import 'package:ecommerce_mobile/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryDataProvider with ChangeNotifier {
  bool loading = false;

  List<CategoryModel> categories = [];

  Future<List<CategoryModel>> getCategories(context) async {
    final response =
        await http.get(Uri.parse('http://qsres.com/api/mobileapp/categories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((item) => new CategoryModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Kategoriler yüklenemedi!');
    }
  }

  getPostData(context) async {
    loading = true;
    categories = await getCategories(context);
    loading = false;

    //notifyListeners();
  }
}