import 'package:shop_flutter/model/utility/in_app.dart';
import 'package:shop_flutter/repository/load_more/load_more_inapp_repository.dart';
import 'package:shop_flutter/ui/inapp/inapp_item.dart';
import 'package:shop_flutter/view/utility/custom_load_more_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ListInApp extends StatefulWidget {
  ListInApp({this.kind, this.initData, this.topObject});

  final kind;
  final initData;

  final Widget topObject;

  @override
  _BuildAllViewState createState() => _BuildAllViewState();
}

class _BuildAllViewState extends State<ListInApp> {
  LoadMoreInAppRepository listSourceRepository;

  @override
  void initState() {
    super.initState();
    listSourceRepository = new LoadMoreInAppRepository(widget.kind, initData: widget.initData);
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listSourceRepository.kind = widget.kind;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Material(
        child: LoadingMoreCustomScrollView(
          showGlowLeading: false,
          slivers: <Widget>[
            widget.topObject ?? SliverToBoxAdapter(),
            SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                sliver: LoadingMoreSliverList(_buildByView()))
          ],
        ),
      ),
    );
  }

  SliverListConfig<InApp> _buildByView() {
    return SliverListConfig<InApp>(
      itemBuilder: ItemBuilder.itemBuilderList,
      sourceList: listSourceRepository,
      indicatorBuilder: _buildIndicator,
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return CustomLoadMoreIndicator(listSourceRepository, status, noMoreLoadText: 'Đã hiện thị tất cả tin',emptyText: 'Không có tin nào',);
  }

  Future<void> onRefresh() async {
    return await listSourceRepository.refresh(false);
  }
}

class ItemBuilder {
  static Widget itemBuilderList(BuildContext context, InApp item, int index) {
    return Container(child: InAppItem(item));
  }
}
