import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/category.dart';
import 'package:shop_flutter/model/product/product_detail.dart';
import 'package:shop_flutter/model/product/product_filter.dart';
import 'package:shop_flutter/repository/product_repository.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';

class InfoProduct extends StatefulWidget {
  InfoProduct(this.detail);

  final ProductDetail detail;

  @override
  _InfoProductState createState() => _InfoProductState(detail);
}

class _InfoProductState extends State<InfoProduct> {
  _InfoProductState(this.detail);

  initState() {
    super.initState();
    isFull = false;
  }

  final ProductDetail detail;
  bool isFull;

  @override
  Widget build(BuildContext context) {
    var styleButton =
        Theme.of(context).textTheme.button.merge(TextStyle(color: Colors.blue));

    /// 0 Title
    List<Widget> children = [
      Container(height: 10, color: ANNColor.dividerColor),
      _buildTitle('Thông tin chi tiết'),
      Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text('Mã'),
          ),
          Expanded(
            flex: 3,
            child: Text(
              detail.sku,
            ),
          ),
        ],
      )
    ];

    /// 1 Category
    children.add(Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text('Danh mục'),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {
              ListProduct.showByCategory(
                  context,
                  Category(
                      name: detail.categoryName,
                      filter:
                          ProductFilter(categorySlug: detail.categorySlug)));
            },
            child: Text('${detail.categoryName}', style: styleButton),
          ),
        )
      ],
    ));

    /// 2 TAG
    if (Utility.isNullOrEmpty(detail.tags) == false) {
      children.add(Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text('TAG'),
          ),
          Expanded(
            flex: 3,
            child: Wrap(
              children: detail.tags
                  .map((item) => InkWell(
                        onTap: () {
                          ListProduct.showByCategory(
                              context,
                              Category(
                                  name: item.name,
                                  filter: ProductFilter(tagSlug: item.slug)));
                        },
                        child: Text(
                          item.name + ', ',
                          style: styleButton,
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ));
    }

    /// 3 Color
    if (Utility.isNullOrEmpty(detail.colors) == false) {
      children.add(Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text('Màu'),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'product/detail/select-size-color',
                    arguments: {'index': 0, 'data': detail});
              },
              child: Wrap(
                children: detail.colors
                    .map((item) => Text(
                          item.name + ', ',
                          style: styleButton,
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ));
    }

    /// 4 Size
    if (Utility.isNullOrEmpty(detail.sizes) == false) {
      children.add(Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text('Size'),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'product/detail/select-size-color',
                    arguments: {'index': 0, 'data': detail});
              },
              child: Wrap(
                children: detail.sizes
                    .map((item) => Text(
                          item.name + ', ',
                          style: styleButton,
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ));
    }

    /// 5 Materials
    if (Utility.isNullOrEmpty(detail.materials) == false) {
      children.add(Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text('Chất liệu'),
          ),
          Expanded(
            flex: 3,
            child: Text(detail.materials),
          ),
        ],
      ));
    }

    /// 5 Status
    children.add(Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text('Trạng thái'),
        ),
        Expanded(
          flex: 3,
          child: Text(ProductRepository.instance.getBadgeName(detail.badge)),
        ),
      ],
    ));

    /// 6 View
    if (Utility.isNullOrEmpty(detail.discounts) == false) {
      children.add(_buildTitle('Chiết khấu'));
      if (isFull) {
        for (var item in detail.discounts) {
          children.add(Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(item.name),
              ),
              Expanded(
                flex: 3,
                child: Text(Utility.formatPrice(item.price)),
              ),
            ],
          ));
        }
      }
      children.add(_buttonControlView());
    }

    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (_, index) {
        return index == 0
            ? children[index]
            : Container(
                decoration: index % 2 != 0
                    ? BoxDecoration()
                    : BoxDecoration(color: Colors.grey[200]),
                padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: 12),
                child: children[index],
              );
      },
      childCount: children.length,
    ));
  }

  _buttonControlView() {
    return InkWell(
      onTap: () {
        setState(() {
          isFull = !isFull;
        });
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              isFull ? 'Thu gọn ' : 'Xem thêm ',
              style: Theme.of(context)
                  .textTheme
                  .button
                  .merge(TextStyle(color: Colors.blue)),
            ),
            Icon(
              isFull ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }

  _buildTitle(title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }
}
