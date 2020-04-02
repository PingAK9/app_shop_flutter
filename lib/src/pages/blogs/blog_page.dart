import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/utility/blog_category.dart';
import 'package:shop_flutter/provider/utility/blog_provider.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/utility/request_login.dart';
import 'package:shop_flutter/view/inapp/list_blog.dart';
import 'package:shop_flutter/view/utility/custom_load_more_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      Provider.of<BlogProvider>(context, listen: false).checkReload();
    });
  }

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = Provider.of<BlogProvider>(context);
    String title;
    String slug;

    // Get title
    if (provider.currentCategory == null)
      title = 'Bài viết';
    else
      title = provider.currentCategory.name;

    // Get slug
    if (provider.currentCategory == null)
      slug = null;
    else
      slug = provider.currentCategory.filter.categorySlug;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: AccountController.instance.isLogin == false
          ? RequestLogin()
          : ListBlog(
              slug,
              topObject: _buildCategoryButtonList(provider),
            ),
    );
  }

  Widget _buildCategoryButtonList(BlogProvider provider) {
    if (Utility.isNullOrEmpty(provider.category.data)) return null;

    var categories = provider.category.data;
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: CommonSliverPersistentHeaderDelegate(
          Container(
            color: ANNColor.white,
            padding: EdgeInsets.only(top: 20, bottom: 5),
            width: double.infinity,
            child: ListView.separated(
              itemBuilder: (context, index) {
                index -= 1;
                if (index < 0 || index == categories.length) {
                  return SizedBox(
                    width: 5,
                  );
                }
                BlogCategory item = categories[index];
                bool selected = item.filter.categorySlug ==
                    provider.currentCategory.filter.categorySlug;
                return ChoiceChip(
                  label: Text(
                    item.name,
                    textAlign: TextAlign.center,
                  ),
                  selected: selected,
                  onSelected: (value) {
                    provider.currentCategory = item;
                  },
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 10,
                );
              },
              itemCount: categories.length + 2,
              scrollDirection: Axis.horizontal,
            ),
          ),
          55),
    );
  }
}
