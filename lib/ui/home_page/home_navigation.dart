import 'dart:ui';

import 'package:shop_flutter/core/app_icons.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/src/models/ann_page.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';

class HomeNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(width: 10, color: ANNColor.dividerColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RoundedButton(
            title: 'Tra giá',
            onItemTapped: () {
              Routes.navigateHome(context, ANNPage.scan);
            },
            icon: AppIcons.qrcode,
            color: Color(0xff5aac44),
          ),
          RoundedButton(
            title: 'Bài viết',
            onItemTapped: () {
              Navigator.pushNamed(context, 'blog');
            },
            icon: AppIcons.blogger,
            color: Colors.blueAccent,
          ),
          RoundedButton(
            title: 'Khuyến mãi',
            onItemTapped: () => Routes.navigateHome(
                context, ANNPage.notification,
                notificationType: 'promotion'),
            icon: Icons.local_atm,
            color: Colors.red,
          ),
          RoundedButton(
            title: 'Chính sách',
            onItemTapped: () {
              Navigator.pushNamed(context, 'shop/policy');
            },
            icon: Icons.question_answer,
            color: ANNColor.orange,
          ),
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final GestureTapCallback onItemTapped;

  RoundedButton(
      {this.color = ANNColor.white,
      @required this.icon,
      @required this.title,
      @required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: onItemTapped,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    color.withAlpha(200),
                    color,
                    color.withAlpha(180)
                  ]),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: new Border.all(
                    color: ANNColor.white,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      offset: Offset(1.0, 2.0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 30,
                  color: ANNColor.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              this.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
