import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/ui/product_ui/badge_tag_product_ui.dart';
import 'package:shop_flutter/ui/utility/app_image.dart';
import 'package:flutter/material.dart';

class ProductBlock extends StatelessWidget {
  ProductBlock(this.product, {this.imageHeight = 200});

  final Product product;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Routes.showProductDetail(context, product: product);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: imageHeight,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                AppImage(product.getCover),
                Positioned(
                  left: 0,
                  top: 0,
                  child: BadgeTagProductUI(product.badge),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.body1,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Mã: ' + product.sku,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .merge(TextStyle(color: Colors.grey)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Sỉ: ' + Utility.formatPrice(product.regularPrice),
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .merge(TextStyle(color: Colors.red)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Lẻ: ' + Utility.formatPrice(product.retailPrice),
              style: Theme.of(context).textTheme.body2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
