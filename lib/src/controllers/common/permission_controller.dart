import 'dart:io';

import 'package:shop_flutter/src/controllers/ann_controller.dart';
import 'package:shop_flutter/src/widgets/alert_dialog/alert_dialog_permission.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionController extends ANNController {
  // region Singleton Pattern
  static final _instance = PermissionController._internal();

  // endregion

  // region Parameters
  PermissionHandler _permission;

  // endregion

  // region Getter
  static PermissionController get instance => _instance;

  // endregion

  PermissionController._internal() {
    _permission = new PermissionHandler();
  }

  factory PermissionController() => instance;

  Future<bool> checkAndRequestPermission(
      BuildContext context, PermissionGroup name) async {
    var status = await _permission.checkPermissionStatus(name);

    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.unknown) {
      final result = await _permission.requestPermissions([name]);

      status = result[name];

      if (status == PermissionStatus.granted)
        return true;
      else
        return false;
    } else if (status == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showAlertDialog(context, name);

        return false;
      } else {
        final result = await _permission.requestPermissions([name]);

        status = result[name];

        if (status == PermissionStatus.granted)
          return true;
        else
          return false;
      }
    } else if (status == PermissionStatus.neverAskAgain) {
      _showAlertDialog(context, name);

      return false;
    } else {
      return false;
    }
  }

  void _showAlertDialog(BuildContext context, PermissionGroup permission) {
    final alertDialog = AlertDialogPermission.instance;

    alertDialog.setMessage(permission);
    alertDialog.show(context);
  }
}
