import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ecommerce_mobile/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<List<CartModel>> getCartItems() async {
  final response = await http.get(
    Uri.parse("http://qsres.com/api/mobileapp/cart"),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    },
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => new CartModel.fromJson(item)).toList();
  } else {
    throw Exception("Ürün sepete eklenemedi!");
  }
}

Future<List<CartModel>> addToCart(int productId, int pcs) async {
  final uri = Uri.parse('http://qsres.com/api/mobileapp/cart');
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {'productId': productId, 'pcs': pcs};

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await http.post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => new CartModel.fromJson(item)).toList();
  } else {
    throw Exception("Ürün sepete eklenemedi!");
  }
}

Future<CartModel> deleteAnItemCompletely(int productId) async {
  final uri = Uri.parse('http://qsres.com/api/mobileapp/cart');
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {'productId': productId};

  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await http.delete(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  if (response.statusCode == 200) {
    return CartModel.fromJson(json.decode(response.body));
  } else if (response.statusCode == 404) {
    throw Exception("Ürün zaten sepette yok!");
  } else {
    throw Exception("Ürün sepeten silinemedi!");
  }
}

class CartProvider with ChangeNotifier {
  List<CartModel> cartItems = [];

  bool loading = false;

  loadItems() async {
    loading = true;
    cartItems = await getCartItems();
    loading = false;
    notifyListeners();
  }

  insertItem(int productId) {
    addToCart(productId, 1).then((value) => loadItems());
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    cartItems.forEach((cartItem) {
      if (cartItem.isDiscounted) {
        total += cartItem.discountedPrice * cartItem.pcs;
      } else {
        total += cartItem.sellingPrice * cartItem.pcs;
      }
    });
    return total;
  }

  void removeItem(int productId) {
    addToCart(productId, -1).then((value) => loadItems());
    notifyListeners();
  }

  void removeItemCompletely(int productId) {
    deleteAnItemCompletely(productId).then((value) => loadItems());
    notifyListeners();
  }
}
