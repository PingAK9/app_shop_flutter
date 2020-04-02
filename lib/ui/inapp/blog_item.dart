import 'package:shop_flutter/core/app_action.dart';
import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/utility/cover.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/utility/app_image.dart';
import 'package:flutter/material.dart';

class BlogItem extends StatelessWidget {
  BlogItem(this.item);

  final Cover item;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        color: ANNColor.cardColor,
        child: InkWell(
          onTap: () {
            AppAction.instance.onHandleAction(
                context, item.action, item.actionValue, item.name);
          },
          child: IntrinsicWidth(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Utility.isNullOrEmpty(item.image)
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(top: 8),
                        child: AppImage(
                          item.image,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    maxLines: 20,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                          text: item.message + '...',
                          style: Theme.of(context).textTheme.body1),
                      TextSpan(
                        text: 'xem thêm >',
                        style: Theme.of(context).textTheme.body1.merge(
                              TextStyle(color: Colors.blue),
                            ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
