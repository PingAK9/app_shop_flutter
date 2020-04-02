import 'package:flutter/material.dart';

class ButtonGradient extends StatelessWidget {

  ButtonGradient({this.child, this.onTap});
  final child;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.centerLeft,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white10,
              Color(0xfff4f4f4),
              Color(0xffeaeaea),
              Color(0xfff4f4f4)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: new Border.all(
            color: Colors.grey,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[child, Icon(Icons.keyboard_arrow_down)],
        ),
      ),
    );
  }
}
