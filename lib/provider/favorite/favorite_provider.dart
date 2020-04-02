import 'dart:convert';
import 'dart:core';

import 'package:shop_flutter/core/storage_manager.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/model/product/product_favorite.dart';
import 'package:shop_flutter/ui/utility/app_snackbar.dart';
import 'package:shop_flutter/ui/utility/ask_login.dart';
import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  FavoriteProvider() {
    loadShoppingList();
  }

  final String _keyLocaleFavorite = '_keyLocaleFavorite';
  List<ProductFavorite> products;

  Future loadShoppingList() async {
    try {
      /// shopping
      final response = await StorageManager.getObjectByKey(_keyLocaleFavorite);
      if (Utility.isNullOrEmpty(response)) {
        products = [];
      } else {
        final message = json.decode(response);
        final list = message as List;
        products = list.map((item) => ProductFavorite.fromJson(item)).toList();
      }
    } catch (e) {
      products = [];
    }
  }

  saveShoppingList() {
    var myJsonString =
        json.encode(products.map((value) => value.toJson()).toList());
    StorageManager.setObject(_keyLocaleFavorite, myJsonString);
  }

  addNewProduct(context, Product item, {int count = 1}) {
    if (AccountController.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }

    List<ProductFavorite> array =
        products.where((p) => p.product.productID == item.productID).toList();
    if (Utility.isNullOrEmpty(array)) {
      products.add(ProductFavorite(product: item, count: count));
    } else {
      array[0].count = count;
    }
    saveShoppingList();
    notifyListeners();
    AppSnackBar.showHighlightTopMessage(
        context, 'Đã lưu vào danh sách yêu thích');
  }

  changeCount(ProductFavorite favorite, int _count) {
    if (_count <= 0) {
      products.remove(favorite);
    } else {
      favorite.count = _count;
    }
    saveShoppingList();
    notifyListeners();
  }

  removeAllProductProvider() {
    products = new List();
    saveShoppingList();
    notifyListeners();
  }

  removeProduct(int productID) {
    products.removeWhere((p) => p.product.productID == productID);
    saveShoppingList();
    notifyListeners();
  }

  bool containsInFavorite(int productID) {
    for (var m in products) {
      if (m.product.productID == productID) return true;
    }
    return false;
  }
}
