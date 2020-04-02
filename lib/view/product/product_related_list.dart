import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/product_related.dart';
import 'package:shop_flutter/repository/load_more/load_more_product_relate_repository.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/product/product_related_item.dart';
import 'package:shop_flutter/view/utility/custom_load_more_indicator_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ProductRelatedList extends StatefulWidget {
  ProductRelatedList(this.slug, {this.initData});

  final slug;
  final initData;

  @override
  _ProductRelatedListState createState() => _ProductRelatedListState();
}

class _ProductRelatedListState extends State<ProductRelatedList> {
  LoadMoreProductRelateRepository listSourceRepository;

  @override
  void initState() {
    super.initState();

    listSourceRepository = new LoadMoreProductRelateRepository(
      widget.slug,
      initData: widget.initData,
    );
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ProductRelated> related = widget.initData;
    if (Utility.isNullOrEmpty(related) == false) {
      int row = related.length >= itemPerPage ? 3 : related.length >= 5 ? 2 : 1;
      double size = 135.0 * row;
      return SliverToBoxAdapter(
          child: Container(
        decoration: BoxDecoration(
          border: new Border(
            top: BorderSide(
              color: ANNColor.dividerColor,
              width: 10,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Text(
                'Thuộc tính',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              height: size,
              child: _buildLoadMore(row),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ));
    } else {
      return SliverToBoxAdapter();
    }
  }

  Widget _buildLoadMore(row){
    return LoadingMoreCustomScrollView(
      scrollDirection : Axis.horizontal,
      showGlowLeading: false,
      slivers: <Widget>[
        SliverToBoxAdapter(child: SizedBox(width: 15,),),
        SliverPadding(
          padding: EdgeInsets.only(top: 1),
            sliver: LoadingMoreSliverList(
                SliverListConfig<ProductRelated>(
                  itemBuilder:itemBuilder,
                  sourceList: listSourceRepository,
                  indicatorBuilder: _buildIndicator,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: row,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.45,
                  ),
                ),
            ))
      ],
    );
  }
  Widget itemBuilder(BuildContext context, ProductRelated item, int index) {
    return Container(child: ProductRelatedItem(item));
  }
  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return CustomLoadMoreIndicatorHorizontal(listSourceRepository, status);
  }
}
