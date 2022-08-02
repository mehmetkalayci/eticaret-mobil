import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ecommerce_mobile/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

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

class CartProvider with ChangeNotifier {
  List<CartModel> cartItems = [];

  bool loading = false;

  getPostData() async {
    loading = true;
    cartItems = await getCartItems();
    loading = false;
    notifyListeners();
  }

  List<CartModel> get items {
    return cartItems.toList();
  }

  int get itemCount {
    return cartItems.length;
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

  void addItem(int productId, String productName, double sellingPrice,
      double discountedPrice, int pcs, bool isDiscounted, String thumbSrc) {
    var item = cartItems.firstWhereOrNull((x) => x.productId == productId);
    if (item != null) {
      item.pcs++;
    } else {
      items.add(
        CartModel(
          productId: productId,
          productName: productName,
          sellingPrice: sellingPrice,
          discountedPrice: discountedPrice,
          pcs: pcs,
          isDiscounted: isDiscounted,
          thumbSrc: thumbSrc,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(int productId) {
    var item =
        items.firstWhereOrNull((element) => element.productId == productId);
    if (item != null) {
      items.remove(item);
    }
    notifyListeners();
  }

  void removeSingleItem(int productId) {
    var item = cartItems.where((x) => x.productId == productId).first;
    if (item != null) {
      if (item.pcs > 1) {
        item.pcs--;
      } else {
        items.remove(item.productId);
      }
    }
    notifyListeners();
  }

  void clear() {
    items.clear();
    notifyListeners();
  }
}
