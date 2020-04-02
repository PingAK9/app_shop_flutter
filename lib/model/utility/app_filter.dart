import 'package:shop_flutter/model/product/product_filter.dart';

class AppFilter {
  int sort;
  int priceMin;
  int priceMax;
  int badge;

  int get countSet {
    int _count = badge > 0 ? 1 : 0;
    if (priceMin > 0 || priceMax > 0) _count++;
    return _count;
  }

  AppFilter({
    this.sort = 4,
    this.priceMin = 0,
    this.priceMax = 0,
    this.badge = 0,
  });

  AppFilter.fromJson(Map<String, dynamic> json) {
    sort = json['sort'];
    priceMin = json['priceMin'];
    priceMax = json['priceMax'];
    badge = json['badge'];
  }

  AppFilter.clone(AppFilter filter) {
    sort = filter.sort;
    priceMin = filter.priceMin;
    priceMax = filter.priceMax;
    badge = filter.badge;
  }

  factory AppFilter.fromCategoryFilter(ProductFilter filter) {
    if (filter == null) {
      return AppFilter();
    } else {
      return AppFilter(
        sort: filter.productSort ?? 4,
        priceMin: filter.priceMin ?? 0,
        priceMax: filter.priceMax ?? 0,
        badge: filter.productBadge ?? 0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort'] = this.sort;
    data['priceMin'] = this.priceMin;
    data['priceMax'] = this.priceMax;
    data['badge'] = this.badge;
    return data;
  }

  bool compare(AppFilter _other) {
    if (_other == null) {
      return false;
    }
    if (sort != _other.sort ||
        badge != _other.badge ||
        priceMin != _other.priceMin ||
        priceMax != _other.priceMax) {
      return false;
    }
    return true;
  }
}
