import 'dart:convert';
import 'dart:core';

import 'package:shop_flutter/core/storage_manager.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:flutter/material.dart';

class SeenProvider with ChangeNotifier {
  final String _keyLocaleSeenProduct = '_keyLocaleSeenProduct';
  List<Product> products;
  final int maxItem = 100;

  SeenProvider() {
    loadListProduct();
  }

  loadListProduct() async {
    try {
      /// shopping
      String response =
          await StorageManager.getObjectByKey(_keyLocaleSeenProduct);
      if (response == null || response.isEmpty) {
        products = new List();
      } else {
        var message = json.decode(response);
        var list = message as List;
        products = list.map((item) => Product.fromJson(item)).toList();
      }
    } catch (e) {
      products = new List();
    }
  }

  saveListProduct() {
    var myJsonString =
        json.encode(products.map((value) => value.toJson()).toList());
    StorageManager.setObject(_keyLocaleSeenProduct, myJsonString);
  }

  addNewProduct(Product item) {
    products.removeWhere((product) =>
        (product.productID == item.productID || product.sku == item.sku));
    products.insert(0, item);
    if (products.length > maxItem) {
      products.removeLast();
    }
    saveListProduct();
    notifyListeners();
  }

  removeAllProductProvider() {
    products = new List();
    saveListProduct();
    notifyListeners();
  }

  removeProduct(int productID) {
    products.removeWhere((p) => p.productID == productID);
    saveListProduct();
    notifyListeners();
  }
}
