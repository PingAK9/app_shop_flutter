import 'dart:math';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:shop_flutter/repository/product_repository.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/product_ui/badge_tag_product_ui.dart';
import 'package:shop_flutter/ui/utility/app_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFull extends StatefulWidget {
  ProductFull(this.product);

  final Product product;

  @override
  _ProductFullState createState() => _ProductFullState();
}

class _ProductFullState extends State<ProductFull> {
  int currentPage = 0;
  bool isDownload = false;
  int itemCount = 9;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemCount = min(widget.product.images.length + 1, 9);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - (defaultPadding * 2);
    double height = width * 4 / 3;
    return Container(
      margin: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(70),
            offset: Offset(1.0, 4.0),
            blurRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: ANNColor.white,
      ),
      child: InkWell(
        onTap: () {
          Routes.showProductDetail(context, product: widget.product);
        },
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: height,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index == (itemCount - 1)) {
                        return Container(
                          color: Colors.grey,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              AppImage(
                                Core.domain + widget.product.images[0],
                                fit: BoxFit.contain,
                              ),
                              Container(
                                color: Colors.black.withAlpha(100),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.filter,
                                      color: ANNColor.white,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Xem thêm',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .merge(
                                              TextStyle(color: ANNColor.white)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return AppImage(
                          Core.domain + widget.product.images[index],
                          fit: BoxFit.contain,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: BadgeTagProductUI(widget.product.badge),
                ),
                Positioned(
                  width: width,
                  child: _buildListDot(),
                  bottom: 15,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Mã: ' + widget.product.sku,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .merge(TextStyle(color: Colors.grey)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Giá sỉ: ' +
                              Utility.formatPrice(widget.product.regularPrice),
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .merge(TextStyle(color: Colors.red)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Giá lẻ: ' +
                              Utility.formatPrice(widget.product.retailPrice),
                          style: Theme.of(context).textTheme.body2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildButtonControl(context),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildButtonControl(context) {
    bool favorite = Provider.of<FavoriteProvider>(context)
        .containsInFavorite(widget.product.productID);
    Color iconColor = Theme.of(context).primaryColor;

    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          favorite
              ? IconButton(
                  color: iconColor,
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context, listen: false)
                        .removeProduct(widget.product.productID);
                  },
                )
              : IconButton(
                  color: iconColor,
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context, listen: false)
                        .addNewProduct(context, widget.product, count: 1);
                  },
                ),
          IconButton(
            icon: Icon(
              Icons.cloud_download,
              color: isDownload ? Colors.grey : iconColor,
            ),
            onPressed: isDownload
                ? null
                : () {
                    ProductRepository.instance
                        .onDownLoad(context, widget.product.productID);
                    setState(() {
                      isDownload = true;
                    });
                  },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: iconColor,
            ),
            onPressed: () {
              ProductRepository.instance.onShare(context, widget.product);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.content_copy,
              color: iconColor,
            ),
            onPressed: () {
              ProductRepository.instance
                  .onCheckAndCopy(context, widget.product.productID);
            },
          ),
        ],
      ),
    );
  }

  _buildListDot() {
    List listIndex = List.generate(itemCount, (index) => index);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listIndex
          .map(
            (index) => Container(
              margin: EdgeInsets.all(2),
              width: index == currentPage ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == currentPage ? ANNColor.white : Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          )
          .toList(),
    );
  }
}
