import 'package:shop_flutter/model/utility/cover.dart';
import 'package:shop_flutter/repository/load_more/load_more_blog_repository.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/inapp/blog_item.dart';
import 'package:shop_flutter/view/utility/custom_load_more_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ListBlog extends StatefulWidget {
  ListBlog(this.slug, {this.initData, this.topObject});

  final slug;
  final initData;
  final Widget topObject;

  @override
  _BuildAllViewState createState() => _BuildAllViewState();
}

class _BuildAllViewState extends State<ListBlog> {
  LoadMoreBlogRepository listSourceRepository;

  @override
  void initState() {
    super.initState();
    listSourceRepository =
        new LoadMoreBlogRepository(widget.slug, initData: widget.initData);
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listSourceRepository.categorySlug = widget.slug;
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

  SliverListConfig<Cover> _buildByView() {
    return SliverListConfig<Cover>(
      itemBuilder: ItemBuilder.itemBuilderList,
      sourceList: listSourceRepository,
      indicatorBuilder: _buildIndicator,
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return CustomLoadMoreIndicator(listSourceRepository, status, noMoreLoadText: 'Đã hiện thị tất cả blog',emptyText: 'Không có blog nào',);
  }

  Future<void> onRefresh() async {
    return await listSourceRepository.refresh(false);
  }
}

class ItemBuilder {
  static Widget itemBuilderList(BuildContext context, Cover item, int index) {
    return Column(children: [
      BlogItem(item),
      Container(height: 6, color: ANNColor.dividerColor),
    ]);
  }
}
