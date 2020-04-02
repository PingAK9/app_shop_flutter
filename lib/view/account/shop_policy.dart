import 'package:shop_flutter/core/app_action.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/utility/cover.dart';
import 'package:shop_flutter/repository/utility_repository.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPolicy extends StatefulWidget {
  @override
  _ShopPolicyState createState() => _ShopPolicyState();
}

class _ShopPolicyState extends State<ShopPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chính sách bán hàng'),
      ),
      body: FutureProvider<List<Cover>>(
          create: (_) => UtilityRepository.instance.loadPolicy(),
          child: Consumer<List<Cover>>(
            builder: (key, List<Cover> data, child) {
              if (Utility.isNullOrEmpty(data)) {
                return Indicator();
              } else {
                return ListView(
                  children: data.map((item) => _buildItem(item)).toList(),
                );
              }
            },
          )),
    );
  }

  Widget _buildItem(Cover item) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      color: ANNColor.white,
      child: ListTile(
        onTap: () {
          AppAction.instance.onHandleAction(
              context, item.action, item.actionValue, item.name);
        },
        leading: Icon(
          Icons.question_answer,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(item.name),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: ANNColor.dividerColor),
      ),
    );
  }
}
