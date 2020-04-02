import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/provider/category/category_provider.dart';
import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/src/controllers/common/user_controller.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/home_page/category_button.dart';
import 'package:shop_flutter/ui/favorite/favorite_button.dart';
import 'package:shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:shop_flutter/view/search/search_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: Scaffold(
        body: CustomScrollView(
//            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: ANNColor.orange,
                title: Padding(
                    padding: EdgeInsets.only(left: defaultPadding),
                    child: SearchTitle('Bạn tìm gì hôm nay?')),
                titleSpacing: 0,
                actions: <Widget>[
                  FavoriteButton(
                    color: ANNColor.white,
                  ),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                sliver: _buildCategory(),
              ),
            ]),
      ),
    );
  }

  _buildCategory() {
    var provider = Provider.of<CategoryProvider>(context);
    if (provider.categories.isLoading) {
      return SliverFillRemaining(
        child: Center(
          child: Indicator(),
        ),
      );
    } else if (provider.categories.isError) {
      return SliverFillRemaining(
        child: SomethingWentWrong(
          onReload: () {
            _refreshPage();
          },
        ),
      );
    } else {
      if (Utility.isNullOrEmpty(provider.categories.data)) {
        return SliverFillRemaining(
          child: EmptyListUI(
            body: 'Không tìm thấy danh mục',
          ),
        );
      } else {
        var data = provider.categories.data;
        double width = MediaQuery.of(context).size.width - 30;
        int column = (width / 100).floor();
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return CategoryButton(data[index]);
            },
            childCount: data.length,
          ),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: column,
          ),
        );
      }
    }
  }

  Future<void> _refreshPage() async {
    await UserController.instance.refreshToken(context);
    await Provider.of<CategoryProvider>(context, listen: false)
        .loadCategories();
  }
}
