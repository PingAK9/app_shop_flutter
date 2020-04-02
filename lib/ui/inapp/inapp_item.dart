import 'package:shop_flutter/core/app_action.dart';
import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/utility/in_app.dart';
import 'package:shop_flutter/repository/inapp_repository.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/utility/app_image.dart';
import 'package:shop_flutter/ui/utility/app_popup.dart';
import 'package:flutter/material.dart';

class InAppItem extends StatelessWidget {
  const InAppItem(this.item);

  final InApp item;

  @override
  Widget build(BuildContext context) {
    bool isNew = false;
    return InkWell(
      onTap: () {
        if (Utility.isNullOrEmpty(item.action)) {
          AppPopup.showCustomDialog(
            context,
            title: item.name,
            content: [
              Text(item.message),
              FlatButton(
                child: const Text('Đóng'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        } else {
          AppAction.instance.onHandleAction(
              context, item.action, item.actionValue, item.name);
        }
      },
      child: Container(
        color: isNew ? Colors.lightBlue[50] : ANNColor.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 35,
                    height: 35,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            InAppRepository.instance.getColorInApp(item.kind)),
                    child: Icon(
                      InAppRepository.instance.getIconInApp(item.kind),
                      color: ANNColor.white,
                    ),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            textAlign: TextAlign.start,
                            maxLines: 10,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.date_range,
                                size: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                Utility.fixFormatDate(item.createdDate),
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                            ],
                          )
                        ]),
                  ),
                ],
              ),
            ),
            if (Utility.isNullOrEmpty(item.image) == false)
              Container(
                padding:
                    EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 8),
                child: AppImage(
                  item.image,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 10),
              child: RichText(
                maxLines: 20,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: '${item.message}...',
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
            Container(
              height: 1,
              color: ANNColor.dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}
