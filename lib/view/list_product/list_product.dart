import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/model/product/category.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/model/product/product_filter.dart';
import 'package:shop_flutter/model/utility/app_filter.dart';
import 'package:shop_flutter/provider/utility/config_provider.dart';
import 'package:shop_flutter/provider/utility/search_provider.dart';
import 'package:shop_flutter/repository/load_more/load_more_product_repository.dart';
import 'package:shop_flutter/ui/product/product_block.dart';
import 'package:shop_flutter/ui/product/product_full.dart';
import 'package:shop_flutter/ui/product/product_title.dart';
import 'package:shop_flutter/ui/product_ui/config_product_ui.dart';
import 'package:shop_flutter/view/utility/custom_load_more_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:provider/provider.dart';

class ListProduct extends StatefulWidget {
  ListProduct(this.filter, {this.productFilter, this.topObject, this.initData});

  final ProductFilter productFilter;
  final initData;
  final Widget topObject;

  final AppFilter filter;

  @override
  _BuildAllViewState createState() => _BuildAllViewState();

  static showByCategory(context, Category category,
      {List<Product> initData, showSearch = false}) async {
    var data = {'category': category, 'initData': initData, 'showSearch': true};
    await Navigator.pushNamed(context, 'product', arguments: data);
  }

  static showBySearch(context, Category category,
      {List<Product> initData}) async {
    Provider.of<SearchProvider>(context, listen: false).setText();
    var data = {'category': category, 'initData': initData, 'showSearch': true};
    if (Navigator.canPop(context)) {
      await Navigator.pushReplacementNamed(context, 'product', arguments: data);
    } else {
      await Navigator.pushNamed(context, 'product', arguments: data);
    }
  }
}

class _BuildAllViewState extends State<ListProduct> {
  LoadMoreProductRepository listSourceRepository;

  @override
  void initState() {
    super.initState();

    listSourceRepository = new LoadMoreProductRepository(
        productFilter: widget.productFilter,
        initData: widget.initData,
        appFilter: widget.filter);
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfigProvider config = Provider.of(context);
    listSourceRepository.setFilter(widget.filter);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Material(
        child: LoadingMoreCustomScrollView(
          showGlowLeading: false,
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: CommonSliverPersistentHeaderDelegate(
                  ConfigProductUI(widget.filter), 60),
            ),
            widget.topObject ??
                SliverToBoxAdapter(
                  child: Container(
                    height: 20,
                  ),
                ),
            SliverPadding(
                padding: (config.view == ViewType.grid)
                    ? EdgeInsets.symmetric(horizontal: defaultPadding)
                    : EdgeInsets.symmetric(horizontal: 0),
                sliver: LoadingMoreSliverList(_buildByView()))
          ],
        ),
      ),
    );
  }

  SliverListConfig<Product> _buildByView() {
    ConfigProvider config = Provider.of(context);
    if (config.view == ViewType.grid) {
      final textHeight = 140.0;
      final double screenWidth = MediaQuery.of(context).size.width;
      final countPerRow = screenWidth < 450 ? 2 : 3;
      final imageWidth =
          (screenWidth - ((countPerRow + 1) * defaultPadding)) / countPerRow;
      final imageHeight = imageWidth * 4 / 3;
      final childAspectRatio = imageWidth / (imageHeight + textHeight);
      return SliverListConfig<Product>(
        itemBuilder: ItemBuilder.itemBuilderGrid,
        sourceList: listSourceRepository,
        indicatorBuilder: _buildIndicator,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: countPerRow,
          mainAxisSpacing: defaultPadding,
          crossAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio,
        ),
      );
    } else {
      return SliverListConfig<Product>(
        itemBuilder: config.view == ViewType.list
            ? ItemBuilder.itemBuilderList
            : ItemBuilder.itemBuilderBig,
        sourceList: listSourceRepository,
        indicatorBuilder: _buildIndicator,
      );
    }
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return CustomLoadMoreIndicator(listSourceRepository, status);
  }

  Future<void> onRefresh() async {
    return await listSourceRepository.refresh(false);
  }
}

class ItemBuilder {
  static Widget itemBuilderList(BuildContext context, Product item, int index) {
    return Container(child: ProductTitle(item));
  }

  static Widget itemBuilderBig(BuildContext context, Product item, int index) {
    return ProductFull(item);
  }

  static Widget itemBuilderGrid(BuildContext context, Product item, int index) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final countPerRow = screenWidth < 450 ? 2 : 3;
    final imageWidth =
        (screenWidth - ((countPerRow + 1) * defaultPadding)) / countPerRow;
    final imageHeight = imageWidth * 4 / 3;

    return ProductBlock(
      item,
      imageHeight: imageHeight,
    );
  }
}
