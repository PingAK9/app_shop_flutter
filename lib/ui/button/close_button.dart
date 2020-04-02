import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyCloseButton extends StatelessWidget {
  const MyCloseButton({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: ANNColor.white,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withAlpha(70),
              offset: Offset(1.0, 4.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Icon(
          Icons.close,
          color: Colors.black45,
        ),
      ),
    );
  }
}
