import 'dart:math';

import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/provider/product/seen_provider.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/button/bottom_view_more.dart';
import 'package:shop_flutter/ui/product/product_item.dart';
import 'package:shop_flutter/ui/utility/title_view_more.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeenBlock extends StatelessWidget {
  SeenBlock({this.exceptID});

  final int exceptID;
  final limit = 10;

  @override
  Widget build(BuildContext context) {
    final imageWidth = 150.0;
    final imageHeight = 200.0;
    SeenProvider provider = Provider.of(context);
    List<Widget> children = [];
    int length =
        provider.products == null ? 0 : min(provider.products.length, limit);
    for (int i = 0; i < length; i++) {
      if (provider.products[i] != null &&
          exceptID != provider.products[i].productID) {
        children.add(ProductItem(
          provider.products[i],
          width: imageWidth,
          imageHeight: imageHeight,
        ));
      }
    }
    if (Utility.isNullOrEmpty(children) == false) {
      return SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
//            color: Colors.white,
            border: new Border(
              top: BorderSide(
                color: ANNColor.dividerColor,
                width: 10,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Column(
            children: <Widget>[
              TitleViewMore(
                title: 'Sản phẩm đã xem',
              ),
              Container(
                height: imageHeight + 140,
                padding: EdgeInsets.only(left: 0, right: 0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: children,
                ),
              ),
              BottomViewMore(
                onPressed: () {
                  Navigator.pushNamed(context, 'user/seen');
                },
              )
            ],
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter();
    }
  }
}
