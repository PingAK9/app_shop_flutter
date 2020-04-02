import 'dart:math';

import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight = 130;

  MySliverAppBar({@required this.title, this.leading, this.actions});

  final String title;
  Widget leading;
  final List<Widget> actions;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    /// 0 -> 1
    double dt = shrinkOffset / expandedHeight;
    if (leading == null && Navigator.canPop(context)) {
      leading = IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          bottom: BorderSide(color: ANNColor.dividerColor, width: 1),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          Container(
            padding:
                EdgeInsets.only(left: 15 - (dt * 15), bottom: 15 - (dt * 15)),
            child: Align(
              alignment: Alignment(min(0, (dt * 1.2) - 1.0), 1 - dt),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28 - (dt * 10),
                  color: Colors.grey[800]
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: kToolbarHeight - 1,
              child: Row(
                children: <Widget>[
                  leading ?? Container(),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  actions != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: actions,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
