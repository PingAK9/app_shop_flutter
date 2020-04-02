import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  BorderButton(this.title, {this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: ANNColor.white,
          border: new Border.all(
            color: onPressed == null
                ? ANNColor.grey
                : Theme.of(context).primaryColor,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          )),
      child: FlatButton(
        child: Text(
          title,
          style: Theme.of(context).textTheme.button.merge(TextStyle(
                color: onPressed == null
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              )),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
