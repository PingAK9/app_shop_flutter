import 'package:shop_flutter/model/product/product_detail.dart';
import 'package:shop_flutter/model/product/product_related.dart';
import 'package:shop_flutter/provider/response_provider.dart';
import 'package:shop_flutter/repository/product_repository.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider() {
    // instructor
  }

  Map<String, ResponseProvider<ProductDetail>> products = new Map();
  Map<String, ResponseProvider<List<ProductRelated>>> related = new Map();

  ResponseProvider<ProductDetail> getBySlug(String code) {
    if (products[code] == null) {
      products[code] = ResponseProvider<ProductDetail>();
      loadProduct(code);
    }
    return products[code];
  }

  ResponseProvider<List<ProductRelated>> getRelatedBySlug(String code) {
    if (related[code] == null) {
      related[code] = ResponseProvider<List<ProductRelated>>();
      loadRelatedProduct(code);
    }
    return related[code];
  }

  loadProduct(String code) async {
    try {
      products[code].loading = 'Loading';
      var data = await ProductRepository.instance.loadProductDetail(code);
      if (data == null) {
        products[code].error = 'Load fail';
      } else {
        products[code].completed = data;
      }
      notifyListeners();
    } catch (e) {
      products[code].error = 'Exception: ' + e.toString();
      notifyListeners();
    }
  }

  loadRelatedProduct(String code) async {
    try {
      related[code].loading = 'Loading';
      var data = await ProductRepository.instance.loadRelatedOfProduct(code);
      if (data == null) {
        related[code].error = 'Load fail';
      } else {
        related[code].completed = data;
      }
      notifyListeners();
    } catch (e) {
      related[code].error = 'Exception: ' + e.toString();
      notifyListeners();
    }
  }
}
