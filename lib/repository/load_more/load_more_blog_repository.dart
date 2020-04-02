import 'dart:async';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/model/utility/cover.dart';
import 'package:shop_flutter/repository/blog_repository.dart';
import 'package:loading_more_list/loading_more_list.dart';

class LoadMoreBlogRepository extends LoadingMoreBase<Cover> {
  LoadMoreBlogRepository(String slug, {this.initData}) {
    // TODO:
    categorySlug = slug;
    if (this.initData == null) {
      pageIndex = 1;
    } else {
      pageIndex = 2;
      initData.forEach((item) {
        this.add(item);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Cover> initData;
  int pageIndex;
  String _categorySlug;

  String get categorySlug => _categorySlug;

  set categorySlug(String value) {
    if (value != _categorySlug) {
      _categorySlug = value;
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

      List<Cover> list = await _loadData();

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

  Future<List<Cover>> _loadData() async {
    var list = await BlogRepository.instance
        .loadBlog(categorySlug, page: pageIndex, pageSize: itemPerPage);
    return list;
  }
}
