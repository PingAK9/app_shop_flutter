import 'dart:async';
import 'dart:io';

import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

class LoadingDialog {
  // region Parameters
  BuildContext _context;
  StreamController _streamController;

  // endregion

  // region Setter
  set message(String value) {
    _streamController.add(value);
  }

  // endregion

  LoadingDialog(BuildContext context, {String message = ''}) {
    _context = context;
    _streamController = StreamController();
    _streamController.add(message);
  }

  Future<void> show() async {
    // Create loading by the devices
    if (!(Platform.isIOS || Platform.isAndroid)) return null;

    print(_streamController);
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (_) => new Material(
        type: MaterialType.transparency,
        child: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) => new Center(
                  child: Platform.isIOS
                      ? _iosLoading(snapshot.hasData ? snapshot.data : '')
                      : _androidLoading(snapshot.hasData ? snapshot.data : ''),
                )),
      ),
    );
  }

  void close() {
    _streamController.close();
    Navigator.pop(_context);
  }

  // Create the alert dialog for the IOS
  Container _iosLoading(String message) {
    var children = new List<Widget>();

    // Cupertino Activity Indicator
    children.add(new Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: new CupertinoActivityIndicator(
        radius: 15,
      ),
    ));

    // Text message
    if (!isEmpty(message))
      children.add(new Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        width: double.infinity,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ANNColor.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ));

    return new Container(
      width: isEmpty(message) ? 80 : 130,
      decoration: BoxDecoration(
        color: ANNColor.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  // Create the alert dialog for the Android
  Container _androidLoading(String message) {
    var children = new List<Widget>();

    // Cupertino Activity Indicator
    children.add(new Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            backgroundColor: ANNColor.white,
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Theme.of(_context).primaryColor),
          ),
        )));

    // Text message
    if (!isEmpty(message))
      children.add(new Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        width: double.infinity,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ANNColor.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ));

    return new Container(
      width: isEmpty(message) ? 80 : 130,
      decoration: BoxDecoration(
        color: ANNColor.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
