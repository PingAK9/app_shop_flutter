import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ANNAlertDialog {
  // region Parameters
  String title, message, btnLabel, btnLabelCancel;

  // endregion

  Future<void> show(BuildContext context) async {
    if (!(Platform.isIOS || Platform.isAndroid)) return null;

    var _alert;

    if (Platform.isIOS) _alert = _iosAlertDialog(context);

    if (Platform.isAndroid) _alert = _androidAlertDialog(context);

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _alert,
    );
  }

  // Create the alert dialog for the IOS
  CupertinoAlertDialog _iosAlertDialog(BuildContext context) {
    return new CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(btnLabel),
          onPressed: () => onPressedAccept(context),
        ),
        FlatButton(
          child: Text(btnLabelCancel),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // Create the alert dialog for the Android
  AlertDialog _androidAlertDialog(BuildContext context) {
    return new AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(btnLabel),
          onPressed: () => onPressedAccept(context),
        ),
        FlatButton(
          child: Text(btnLabelCancel),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void onPressedAccept(BuildContext context) {
    Navigator.pop(context);
  }
}
