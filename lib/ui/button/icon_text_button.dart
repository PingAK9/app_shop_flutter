import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  IconTextButton(this.text, this.icon, {this.onPressed});

  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Icon(icon),
            Text(text, maxLines: 1,),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
