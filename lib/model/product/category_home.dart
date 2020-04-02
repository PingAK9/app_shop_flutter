import 'package:shop_flutter/model/product/category.dart';
import 'package:shop_flutter/model/utility/cover.dart';

class CategoryHome {
  Category category;
  Cover banner;

  CategoryHome({this.category, this.banner});

  CategoryHome.fromJson(Map<String, dynamic> json) {
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    banner = json['banner'] != null ? Cover.fromJson(json['banner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category.toJson();
    data['banner'] = this.banner.toJson();
    return data;
  }
}
