import 'dart:io';

import 'package:shop_flutter/core/app_icons.dart';
import 'package:shop_flutter/provider/utility/search_provider.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/src/controllers/common/user_controller.dart';
import 'package:shop_flutter/src/models/ann_page.dart';
import 'package:shop_flutter/ui/utility/search_input.dart';
import 'package:shop_flutter/view/search/search_intro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            onPressed: () {
              if (MediaQuery.of(context).viewInsets.bottom > 100 || true) {
                FocusScope.of(context).requestFocus(FocusNode());
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Routes.navigateSearch(context, ANNPage.home);
                }
              }
            },
          ),
          titleSpacing: 0,
          title: SearchInput(),
          actions: <Widget>[
            IconButton(
              icon: Icon(AppIcons.qrcode),
              onPressed: () {
                Routes.navigateSearch(context, ANNPage.scan);
              },
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            )
          ],
        ),
        body: SearchIntro(),
      ),
      onRefresh: () => _onRefresh(context),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    await UserController.instance.refreshToken(context);
    await searchProvider.loadHotKey();
    await searchProvider.loadHistory();
  }
}
