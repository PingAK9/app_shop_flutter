import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/category.dart';
import 'package:shop_flutter/provider/utility/search_provider.dart';
import 'package:shop_flutter/provider/utility/spam_cover_provider.dart';
import 'package:shop_flutter/ui/product_ui/product_banner.dart';
import 'package:shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchIntro extends StatefulWidget {
  @override
  _SearchIntroState createState() => _SearchIntroState();
}

class _SearchIntroState extends State<SearchIntro> {
  final String slugBanner = 'banners?page=search';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      Provider.of<SpamCoverProvider>(context, listen: false)
          .checkLoad(slugBanner);
    });
  }

  @override
  Widget build(BuildContext context) {
    SearchProvider provider = Provider.of(context);
    bool hasHotKey = Utility.isNullOrEmpty(provider.hotKeys.data) == false;
    bool hasHistory = Utility.isNullOrEmpty(provider.history) == false;

    return RefreshIndicator(
      onRefresh: () async {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 15,
                bottom: 5,
                left: defaultPadding,
                right: defaultPadding),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Từ Khoá Hot',
                    style: Theme.of(context).textTheme.title,
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
          hasHotKey
              ? Padding(
                  padding: EdgeInsets.fromLTRB(
                      defaultPadding, 0, defaultPadding, 10),
                  child: Wrap(
                    children: provider.hotKeys.data
                        .map((title) => _buildHotKey(title))
                        .toList(),
                  ),
                )
              : Container(),
          ProductBanner(
            Provider.of<SpamCoverProvider>(context).getBySlug(slugBanner).data,
          ),
          hasHistory
              ? Container(
                  padding: EdgeInsets.only(
                      top: 15, left: defaultPadding, right: defaultPadding),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.watch_later,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Lịch Sử',
                          style: Theme.of(context).textTheme.title,
                          maxLines: 1,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'XOÁ',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          provider.removeHistoryAll();
                        },
                      )
                    ],
                  ),
                )
              : Container(),
          hasHistory
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Wrap(
                    children: provider.history
                        .map((title) => _buildHistory(context, title))
                        .toList(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildHotKey(Category item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ActionChip(
          label: Text(item.name, textAlign: TextAlign.center),
          onPressed: () {
            ListProduct.showBySearch(context, item);
          }),
    );
  }

  Widget _buildHistory(BuildContext context, String title) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ActionChip(
          label: Text(title, textAlign: TextAlign.center),
          onPressed: () {
            searchProvider.onSearch(context, title);
          }),
    );
  }
}
