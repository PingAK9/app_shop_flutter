import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/provider/category/category_provider.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/src/models/ann_page.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/home_page/category_button.dart';
import 'package:shop_flutter/ui/utility/title_view_more.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCategory extends StatelessWidget {
  HomeCategory();

  @override
  Widget build(BuildContext context) {
    CategoryProvider provider = Provider.of(context);
    var data = provider.categoryHome.data;
    if (Utility.isNullOrEmpty(data)) {
      return Container();
    } else {
      return Container(
        color: ANNColor.blockColor,
        child: Column(
          children: <Widget>[
            TitleViewMore(
              title: 'Danh mục sản phẩm',
              onPressed: () => Routes.navigateHome(context, ANNPage.category),
            ),
            Container(
              height: 200,
              padding: EdgeInsets.only(left: 0, right: 0),
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return CategoryButton(data[index]);
                },
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
