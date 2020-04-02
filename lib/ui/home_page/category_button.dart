import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/model/product/category.dart';
import 'package:shop_flutter/ui/utility/app_image.dart';
import 'package:shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final Category item;

  CategoryButton(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              ListProduct.showByCategory(context, item);
            },
            child: Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: AppImage(this.item.icon, showLoading: false,),
              ),
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            width: 80,
            child: Text(
              this.item.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
