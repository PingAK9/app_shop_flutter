import 'dart:io';

import 'package:shop_flutter/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/strings.dart';

import 'ann_alert_dialog.dart';

class AlertDialogPermission extends ANNAlertDialog {
  // region Singleton Pattern
  static final _instance = AlertDialogPermission._internal();

  // endregion

  // region Getter
  static AlertDialogPermission get instance => _instance;

  // endregion

  AlertDialogPermission._internal() {
    title = 'Cấp quyền cho ${Core.appName}';
    message = 'Vui lòng cấp quyền để sử dụng tín năng này.';
    btnLabel = 'Mở cài đặt';
    btnLabelCancel = 'Bỏ qua';
  }

  factory AlertDialogPermission() => _instance;

  @override
  void onPressedAccept(BuildContext context) {
    PermissionHandler().openAppSettings();

    super.onPressedAccept(context);
  }

  void setMessage(PermissionGroup permission) {
    var strPermission = '';

    if (permission == PermissionGroup.notification)
      strPermission = 'Thông báo';
    else if (permission == PermissionGroup.camera)
      strPermission = Platform.isIOS ? 'Camera' : 'Máy ảnh';
    else if (permission == PermissionGroup.photos ||
        permission == PermissionGroup.storage)
      strPermission = Platform.isIOS ? 'Ảnh' : 'Bộ nhớ';
    else
      strPermission = '';

    if (isEmpty(strPermission))
      message = 'Vui lòng cấp quyền để sử dụng tín năng này.';
    else
      message =
          'Vui lòng cấp quyền sử dụng $strPermission để tín năng này hoạt động.';
    
    if (Platform.isIOS) {
      if (permission == PermissionGroup.camera) {
        message += '\n\nSau khi chọn [Mở cài đặt] -> Kích hoạt [Camera] -> Trở về ứng dụng ANN.';
      } else if (permission == PermissionGroup.photos) {
        message += '\n\nSau khi chọn [Mở cài đặt] -> Chọn [Ảnh] -> Chọn [Đọc và ghi] -> Trở về ứng dụng ANN.';
      }
    } else if (Platform.isAndroid) {
      message += '\n\nSau khi chọn [Mở cài đặt] bên dưới -> Chọn [Quyền] -> Kích hoạt [Bộ nhớ] và [Máy ảnh] -> Trở về ứng dụng ANN.';
    }
  }
}
