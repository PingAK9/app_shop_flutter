import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';

class PolicyProductBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var normalStyle = Theme.of(context).textTheme.body1;
    var boldStyle = Theme.of(context).textTheme.button;
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          height: 10,
          color: ANNColor.dividerColor,
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.local_shipping,
                          size: 35,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Ship COD toàn quốc',style: normalStyle,
                        textAlign: TextAlign.center,)
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: new Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                          color: Theme.of(context).primaryColor.withAlpha(50),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Kiểm tra hàng khi nhận hàng',
                        style: normalStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: new Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                          color: Theme.of(context).primaryColor.withAlpha(50),
                        ),
                        child: Icon(
                          Icons.keyboard_return,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(text: 'Đổi trả hàng trong ', style: normalStyle),
                          TextSpan(text: '30 ngày', style: boldStyle),
                        ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
