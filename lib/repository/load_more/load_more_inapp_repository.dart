import 'dart:async';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/model/utility/in_app.dart';
import 'package:shop_flutter/repository/inapp_repository.dart';
import 'package:loading_more_list/loading_more_list.dart';

class LoadMoreInAppRepository extends LoadingMoreBase<InApp> {
  LoadMoreInAppRepository(String value, {this.initData}) {
    // TODO:
    _kind = value;
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

  final List<InApp> initData;
  String _kind;

  String get kind => _kind;

  set kind(String value) {
    if (value != _kind) {
      _kind = value;
      refresh(true);
    }
  }

  int pageIndex;

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

      List<InApp> list = await _loadData();

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

  Future<List<InApp>> _loadData() async {
    var list = await InAppRepository.instance
        .loadInAppNotification(kind, page: pageIndex, pageSize: itemPerPage);
    return list;
  }
}
