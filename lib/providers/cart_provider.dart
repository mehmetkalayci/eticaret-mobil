import 'dart:convert';

import 'package:ecommerce_mobile/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _storage = SharedPreferences.getInstance();

Future<List<CartModel>?> getCartItems() async {
  Object? token = await (await _storage).get("accessToken");

  final response = await http.get(
    Uri.parse("http://qsres.com/api/mobileapp/cart"),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
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

  final uri = Uri.parse('http://qsres.com/api/mobileapp/cart');
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
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

  final uri = Uri.parse('http://qsres.com/api/mobileapp/cart');
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
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
     await getCartItems().then((value) {
       if(value != null) {
         cartItems.clear();
         value.forEach((element) {
           cartItems.add(element);
         });
       }
    });
  }

  insertItem(int productId, int adet) {
    addToCart(productId, 1).then((value) => loadItems());
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

  int get getTotalItemCount {
    int total = 0;
    cartItems.forEach((cartItem) => total += cartItem.pcs);
    return total;
  }

  void removeItem(int productId) {
    addToCart(productId, -1).then((value) => loadItems());
  }

  void removeItemCompletely(int productId) {
    deleteAnItemCompletely(productId).then((value) => loadItems());
  }
}
