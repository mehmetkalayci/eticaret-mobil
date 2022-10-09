import 'dart:convert';

import 'package:ecommerce_mobile/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _storage = SharedPreferences.getInstance();

Future<List<CartModel>?> getCartItems() async {
  Object? token = await (await _storage).get("accessToken");

  try {
    if (token == null || token == "" || Jwt.isExpired(token.toString())) {
      return null;
    }
  } catch (e) {
    return null;
  }

  final response = await http.get(
    Uri.parse("http://api.qsres.com/mobileapp/cart"),
    headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer ${token.toString()}',
    },
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) => new CartModel.fromJson(item)).toList();
  } else {
    return null;
  }
}

Future<void> addToCart(int productId, int pcs) async {
  Object? token = await (await _storage).get("accessToken");

  final uri = Uri.parse('http://api.qsres.com/mobileapp/cart');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${token.toString()}',
  };

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
    Fluttertoast.showToast(msg: "Ürün sepete eklendi!");
  } else if (response.statusCode == 401) {
    Fluttertoast.showToast(msg: "Sepeti kullanmak için oturum açın!");
  } else {
    Fluttertoast.showToast(msg: response.body);
  }
}

Future<void> deleteAnItemCompletely(int productId) async {
  Object? token = await (await _storage).get("accessToken");

  final uri = Uri.parse('http://api.qsres.com/mobileapp/cart');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${token.toString()}',
  };
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
  } else if (response.statusCode == 401) {
    Fluttertoast.showToast(msg: "Sepeti kullanmak için oturum açın!");
  } else {
    Fluttertoast.showToast(msg: response.body);
  }
}

class CartProvider with ChangeNotifier {
  List<CartModel> cartItems = [];

  loadItems() async {
    List<CartModel>? basketItems = await getCartItems();
    cartItems.clear();
    basketItems?.forEach((item) {
      cartItems.add(item);
    });

    notifyListeners();
  }

  insertItem(int productId, int adet) {
    addToCart(productId, adet).then((value) => loadItems());
  }

  void removeItem(int productId) {
    addToCart(productId, -1).then((value) async {
      await loadItems();
    });
  }

  void removeItemCompletely(int productId) {
    deleteAnItemCompletely(productId).then((value) async {
      await loadItems();
    });
  }

  double _shippingFee = 0.0;

  void setShippingFee(double fee) {
    _shippingFee = fee;
  }

  double _totalAmount = 0.0;

  double get totalAmount {
    _totalAmount = 0.0;

    cartItems.forEach((item) {
      if (item.isDiscounted) {
        _totalAmount += item.discountedPrice * item.pcs;
      } else {
        _totalAmount += item.sellingPrice * item.pcs;
      }
    });

    _totalAmount += _shippingFee;
    return _totalAmount;
  }

  int _getTotalItemCount = 0;

  int get getTotalItemCount {
    _getTotalItemCount = 0;

    cartItems.forEach((item) {
      _getTotalItemCount += item.pcs;
    });

    return _getTotalItemCount;
  }
}
