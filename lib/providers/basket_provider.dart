import 'package:ecommerce_mobile/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BasketProvider with ChangeNotifier {

  List<ProductModel> basketProducts = [];

  addProduct(ProductModel productModel){
    this.basketProducts.add(productModel);
    notifyListeners();
  }


  removeProduct(ProductModel productModel) {
    this.basketProducts.remove(productModel);
    notifyListeners();
  }




}