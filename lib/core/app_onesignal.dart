import 'package:shop_flutter/core/app_action.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppOneSignal {
  factory AppOneSignal() => instance;

  AppOneSignal._internal() {
    _initOneSignal(MyApp.context);
  }

  static final AppOneSignal instance = AppOneSignal._internal();

  String userId;
  String pushToken;
  final _privateKey = "4cfab7f0-6dc2-4004-a631-fc4ba7cbf046";

  void checkAndInit() {}

  Future<void> _initOneSignal(BuildContext context) async {
    await OneSignal.shared.init(_privateKey, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    await OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // will be called whenever the subscription changes
      //(ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });

    OneSignal.shared.setNotificationReceivedHandler((notification) {
//      _processNotificationReceived(notification, false);
    });

    OneSignal.shared.setNotificationOpenedHandler((notificationOpen) {
      _processNotificationReceived(notificationOpen.notification, false);
    });
  }

  void _processNotificationReceived(OSNotification notification, bool init) {
    final payload = notification.payload;
    final launchUrl = payload.launchUrl;
    final data = payload.additionalData;

    if (Utility.isNullOrEmpty(data)) {
      final action = data['action'] ?? '';
      final value = data['actionValue'] ?? '';
      final message = data['message'] ?? 'message';

      if (init) {
        AppAction.instance
            .onHandleActionInit(MyApp.context, action, value, message);
      } else {
        AppAction.instance
            .onHandleAction(MyApp.context, action, value, message);
      }
    } else if (Utility.isNullOrEmpty(launchUrl) == false) {
      launch(launchUrl);
    }
  }

  void sendTag(String name, dynamic value) {
    OneSignal.shared.sendTag(name, value);
  }

  void sendTags(Map<String, dynamic> tags) {
    OneSignal.shared.sendTags(tags);
  }

  void deleteTag(String name) {
    OneSignal.shared.deleteTag(name);
  }

  void deleteTags(List<String> names) {
    OneSignal.shared.deleteTags(names);
  }

  void sendTagsUserInfo() {}
}

class NoticeTags {
  static const String logon = "logon";
  static const String last_name = "full_name";
}
