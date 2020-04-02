import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/material.dart';

class FixViewInsetsBottom extends StatefulWidget {
  @override
  _FixViewInsetsBottomState createState() => _FixViewInsetsBottomState();
}

class _FixViewInsetsBottomState extends State<FixViewInsetsBottom> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 300)).then((v) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Indicator(),
            Container(
              height: 20,
              child: TextField(
                autofocus: true,
                showCursor: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
