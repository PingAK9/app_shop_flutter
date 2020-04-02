import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/utility/coupon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sprintf/sprintf.dart';

class CouponItem extends StatelessWidget {
  const CouponItem(this.item);

  final Coupon item;

  @override
  Widget build(BuildContext context) {
    var code = item.code;
    var discount = sprintf(' (giảm: %dk)', [item.value ~/ 1000]);
    var endDate = Utility.fixFormatDate(item.endDate);

    return Card(
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.only(bottom: 5),
          alignment: Alignment.centerLeft,
          child: Text.rich(TextSpan(children: [
            TextSpan(text: code, style: Theme.of(context).textTheme.title),
            TextSpan(text: discount),
          ])),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.timer,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(endDate)
          ],
        ),
        leading: Container(
            width: 30,
            alignment: Alignment.center,
            child: Icon(MaterialCommunityIcons.ticket_percent)),
      ),
    );
  }
}
