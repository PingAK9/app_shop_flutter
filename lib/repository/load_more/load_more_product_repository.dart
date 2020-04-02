import 'dart:async';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/model/product/product_filter.dart';
import 'package:shop_flutter/model/utility/app_filter.dart';
import 'package:shop_flutter/repository/list_product_repository.dart';
import 'package:loading_more_list/loading_more_list.dart';

class LoadMoreProductRepository extends LoadingMoreBase<Product> {
  LoadMoreProductRepository(
      {this.productFilter, this.initData, AppFilter appFilter}) {
    // TODO:
    _filter = AppFilter.clone(appFilter);
    if (Utility.isNullOrEmpty(this.initData)) {
      pageIndex = 1;
    } else {
      pageIndex = 2;
      initData.forEach((item) {
        this.add(item);
      });
      if (initData.length < itemPerPage) {
        _hasMore = false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Product> initData;
  final ProductFilter productFilter;

  int pageIndex;
  AppFilter _filter;

  setFilter(AppFilter item, {bool force = false}) {
    if (_filter == null || _filter.compare(item) == false || force) {
      _filter = AppFilter.clone(item);
      refresh(true);
    }
  }

  // TODO: implement hasMore
  bool _hasMore = true;
  bool forceRefresh = false;

  bool get hasMore => _hasMore;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    _hasMore = true;
    pageIndex = 1;
    initData = null;
    var result = await super.refresh(true);
    forceRefresh = true;
    return result;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      if (pageIndex == 1) {
        this.clear();
      }

      List<Product> list = await _loadProduct();

      list.forEach((item) {
        this.add(item);
      });

      _hasMore = list.length >= itemPerPage;
      pageIndex++;
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
      _hasMore = false;
      print(e);
    }
    return isSuccess;
  }

  Future<List<Product>> _loadProduct() async {
    if (_filter == null) {
      return [];
    } else {
      if (pageIndex > 1 && AccountController.instance.isLogin == false) {
        return null;
      }
      var list = await ListProductRepository.instance.loadByProductFilter(
          productFilter,
          page: pageIndex,
          pageSize: itemPerPage,
          filter: _filter);
      return list;
    }
  }
}
