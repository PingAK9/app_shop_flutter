import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/product.dart';

class ProductFavorite {
  Product product;
  int count;

  ProductFavorite({this.product, this.count});

  getTextCopy({index}) {
    String value = index != null ? '$index: ' : '';
    value += product.sku;
    value += ' - ';
    value += product.name + '\n';
    value += '💲 ' + Utility.formatPrice(product.regularPrice) + ' vnđ';
    return value;
  }

  ProductFavorite.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    product = Product.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['product'] = this.product.toJson();
    return data;
  }
}
