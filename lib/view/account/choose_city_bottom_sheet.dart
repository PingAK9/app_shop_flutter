import 'package:shop_flutter/repository/account_repository.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/theme/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseCityBottomSheet extends StatelessWidget {
  static void showBottomSheet(context, String currentValue, callback) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext bc) {
        return ChooseCityBottomSheet(currentValue);
      },
    ).then(callback);
  }

  ChooseCityBottomSheet(this.currentValue);

  final currentValue;

  @override
  Widget build(context) {
    List<String> locales = AccountRepository.instance.cityOfVietnam;
    return Container(
      margin: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        color: ANNColor.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Container(
            height: 50,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 40,
                ),
                Expanded(
                  child: Text(
                    'Chọn Tỉnh / Thành phố',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppStyles.dartIcon,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: locales.length,
              itemBuilder: (context, index) {
                return buildItem(context, locales[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, String title) {
    var isChoose = title == currentValue;

    return InkWell(
      onTap: () {
        Navigator.pop(context, title);
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.centerLeft,
        child: isChoose
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.body2,
                  ),
                  Icon(Icons.check),
                ],
              )
            : Text(
                title,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: Theme.of(context).textTheme.body1,
              ),
      ),
    );
  }
}
