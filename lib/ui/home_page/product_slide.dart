import 'dart:math';

import 'package:shop_flutter/core/app_action.dart';
import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/category.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/model/utility/cover.dart';
import 'package:shop_flutter/provider/product/category_product_provider.dart';
import 'package:shop_flutter/src/controllers/common/user_controller.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/button/bottom_view_more.dart';
import 'package:shop_flutter/ui/product/product_item.dart';
import 'package:shop_flutter/ui/utility/app_image.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:shop_flutter/ui/utility/title_view_more.dart';
import 'package:shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSlide extends StatefulWidget {
  ProductSlide(this.group, {this.banner, this.customName});

  final Cover banner;
  final Category group;
  final String customName;

  @override
  _ProductSlideState createState() => _ProductSlideState();
}

class _ProductSlideState extends State<ProductSlide> {
  Category currentCategory;
  ScrollController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController();
    currentCategory = widget.group;
  }

  @override
  Widget build(BuildContext context) {
    CategoryProductProvider provider = Provider.of(context);
    var products = provider.getByCategory(currentCategory);

    return Container(
      color: ANNColor.blockColor,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
            color: ANNColor.dividerColor,
          ),
          TitleViewMore(title: widget.customName ?? widget.group.name),
          Column(
            children: <Widget>[
              _buildBanner(),
              _buildCategoryButtonList(),
              Consumer<CategoryProductProvider>(
                builder: (_, provider, child) {
                  if (products.isLoading) {
                    return buildLoading(context);
                  } else if (products.isError) {
                    return buildError(context);
                  } else {
                    if (Utility.isNullOrEmpty(products.data)) {
                      return buildEmpty(context);
                    } else {
                      return buildProductList(context, products.data);
                    }
                  }
                },
              ),
              BottomViewMore(
                onPressed: () {
                  ListProduct.showByCategory(context, currentCategory,
                      initData: products.data);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildEmpty(BuildContext context) {
    return buildBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.description),
            SizedBox(
              height: 10,
            ),
            Text('Empty'),
          ],
        ),
      ),
    );
  }

  Widget buildError(BuildContext context) {
    return buildBox(
      child: SomethingWentWrong(onReload: () async {
        await UserController.instance.refreshToken(context);
        Provider.of<CategoryProductProvider>(context)
            .loadCategory(currentCategory, refresh: true);
      }),
    );
  }

  Widget buildLoading(BuildContext context) {
    return buildBox(
      child: Indicator(),
    );
  }

  Widget buildBox({@required child}) {
    return Container(
      height: itemHeight - 10,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      decoration: BoxDecoration(
//        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  final imageWidth = 150.0;
  final imageHeight = 200.0;

  double get itemHeight => imageHeight + 140;

  Widget buildProductList(BuildContext context, List<Product> data) {
    int length = min(data.length, 8);
    return Container(
      height: itemHeight,
      padding: EdgeInsets.only(left: 0, right: 0),
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: length + 1,
        itemBuilder: (context, index) {
          if (index == length) {
            return _buildViewMoreButton();
          }
          return ProductItem(
            data[index],
            width: imageWidth,
            imageHeight: imageHeight,
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    if (widget.banner == null) {
      return Container();
    } else {
      Cover item = widget.banner;
      final ratio = 25 / 80;
      final width = MediaQuery.of(context).size.width - (defaultPadding * 2);
      final height = width * ratio;
      return Container(
        margin: EdgeInsets.only(bottom: 15),
        height: height,
        padding: EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 0),
        child: InkWell(
          onTap: () {
            AppAction.instance.onHandleAction(
                context, item.action, item.actionValue, item.name);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: AppImage(
              item.image,
              fit: BoxFit.cover,
              showLoading: true,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildCategoryButtonList() {
    var children = widget.group.children;
    if (Utility.isNullOrEmpty(children)) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 15),
        height: 30,
        width: double.infinity,
        child: ListView.separated(
          itemBuilder: (context, index) {
            index -= 2;
            if (index < -1 || index == children.length) {
              return SizedBox(
                width: 5,
              );
            }
            if (index < 0) {
              return _buildCategoryButton(widget.group, customName: 'Tất cả');
            } else {
              var _child = children[index];
              return _buildCategoryButton(_child);
            }
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10,
            );
          },
          itemCount: children.length + 3,
          scrollDirection: Axis.horizontal,
        ),
      );
    }
  }

  Widget _buildCategoryButton(Category item, {String customName}) {
    String _name = customName ?? item.name;

    bool isSelect = item == currentCategory;
    return ChoiceChip(
      label: Text(
        _name,
        textAlign: TextAlign.center,
        style: TextStyle(color: isSelect ? ANNColor.white : Colors.black87),
      ),
      selected: isSelect,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            currentCategory = item;
            if (controller.hasClients) {
              controller.jumpTo(0);
            }
          });
        }
      },
      selectedColor: Colors.black87,
      disabledColor: Colors.grey,
    );
  }

  _buildViewMoreButton() {
    CategoryProductProvider provider = Provider.of(context);
    var products = provider.getByCategory(currentCategory);
    return Container(
      width: imageWidth + 15,
      padding: EdgeInsets.only(right: 15, bottom: 120),
      child: Center(
        child: InkWell(
          onTap: () {
            ListProduct.showByCategory(context, currentCategory,
                initData: products.data);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.navigate_next,
                  color: ANNColor.white,
                ),
              ),
              Text(
                'Xem thêm',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
