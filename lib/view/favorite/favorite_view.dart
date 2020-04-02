import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/copy_setting/copy_controller.dart';
import 'package:shop_flutter/model/product/product_favorite.dart';
import 'package:shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/src/models/ann_page.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/product/product_favorite_item.dart';
import 'package:shop_flutter/ui/utility/empty_list_ui.dart';
import 'package:shop_flutter/ui/utility/request_login.dart';
import 'package:shop_flutter/view/utility/fix_viewinsets_bottom.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteView extends StatefulWidget {
  @override
  _FavoriteViewState createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  @override
  Widget build(BuildContext context) {
    List<ProductFavorite> data =
        Provider.of<FavoriteProvider>(context).products;
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              if (MediaQuery.of(context).viewInsets.bottom > 100) {
                Navigator.pop(context);
                showDialog(context: context, child: FixViewInsetsBottom());
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text('Danh sách yêu thích'),
          actions: Utility.isNullOrEmpty(data)
              ? null
              : [
                  IconButton(
                    icon: Icon(Icons.delete, color: ANNColor.white),
                    onPressed: _onRemoveAll,
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: ANNColor.white),
                    onPressed: _onShare,
                  ),
                ],
        ),
        body: AccountController.instance.isLogin == false
            ? RequestLogin()
            : Container(
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    Utility.isNullOrEmpty(data)
                        ? _buildEmpty(context)
                        : SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return Column(
                                children: <Widget>[
                                  ProductFavoriteItem(data[index]),
                                  Container(
                                    height: 1,
                                    color: ANNColor.dividerColor,
                                  )
                                ],
                              );
                            }, childCount: data.length),
                          )
                  ],
                ),
              ),
      ),
    );
  }

  _buildEmpty(context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            EmptyListUI(
              body: 'Bạn chưa có sản phẩm nào',
            ),
            SizedBox(height: 5),
            RaisedButton(
              child: Text(
                'Thêm sản phẩm',
                style: TextStyle(color: ANNColor.white),
              ),
              onPressed: () {
                Routes.navigateFavorite(context, ANNPage.home);
              },
            )
          ],
        ),
      ),
    );
  }

  _onShare() {
    List<ProductFavorite> data =
        Provider.of<FavoriteProvider>(context, listen: false).products;
    String _value = '';
    for (int i = 0; i < data.length; i++) {
      _value += data[i].getTextCopy(index: i + 1);
      _value += '\n\n';
    }
    _value += '\n';

    _value += CopyController.instance.copySetting.getUserInfo();
    Share.text('Danh sách sản phẩm yêu thích', _value, 'text/plain');
  }

  _onRemoveAll() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: ANNColor.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          padding: EdgeInsets.fromLTRB(15, 25, 15, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  'Xoá tất cả các sản phẩm trong danh sách yêu thích',
                  textAlign: TextAlign.center,
                ),
              ),
              RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Xác nhận',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .merge(TextStyle(color: ANNColor.white)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Provider.of<FavoriteProvider>(context, listen: false)
                        .removeAllProductProvider();
                  }),
            ],
          ),
        );
      },
    );
  }
}
