import 'package:shop_flutter/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ann_alert_dialog.dart';

class AlertDialogNewVersion extends ANNAlertDialog {
  // region Singleton Pattern
  static final _instance = AlertDialogNewVersion._internal();

  // endregion

  // region Getter
  static AlertDialogNewVersion get instance => _instance;

  // endregion

  AlertDialogNewVersion._internal() {
    title = 'Cập nhật mới';
    message = 'Ứng dụng đã có phiên bản mới.\nVui lòng cập nhật!';
    btnLabel = 'Cập nhật ngay';
    btnLabelCancel = 'Bỏ qua';
  }

  factory AlertDialogNewVersion() => _instance;

  // Launching to the store IOS / Android
  @override
  void onPressedAccept(BuildContext context) async {
    final urlStore = Core.urlStore;

    if (await canLaunch(urlStore)) {
      await launch(urlStore);

      super.onPressedAccept(context);
    } else {
      throw 'Could not launch $urlStore';
    }
  }
}
