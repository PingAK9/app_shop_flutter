import 'dart:convert';
import 'dart:io';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/utility/in_app.dart';
import 'package:shop_flutter/src/controllers/utils/ann_logging.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InAppRepository {
  // region Singleton Pattern
  static final InAppRepository instance = InAppRepository._internal();

  // endregion

  // region Parameters
  ANNLogging logging;

  List<String> categories;

  // endregion

  InAppRepository._internal() {
    logging = ANNLogging.instance;

    categories = ['promotion', 'notification', 'news'];
  }

  factory InAppRepository() => instance;

  String getNameInApp(String category) {
    switch (category) {
      case 'all':
        return 'Thông báo';
        break;
      case 'promotion':
        return 'Khuyến mãi';
        break;
      case 'notification':
        return 'Hoạt động';
        break;
      case 'news':
        return 'Tin tức';
        break;
      default:
        return 'Thông báo';
        break;
    }
  }

  IconData getIconInApp(String category) {
    switch (category) {
      case 'all':
        return Icons.home;
        break;
      case 'promotion':
        return Icons.local_atm;
        break;
      case 'notification':
        return Icons.receipt;
        break;
      case 'news':
        return Icons.description;
        break;
      default:
        return Icons.message;
        break;
    }
  }

  Color getColorInApp(String category) {
    switch (category) {
      case 'all':
        return ANNColor.white;
        break;
      case 'promotion':
        return ANNColor.orange;
        break;
      case 'notification':
        return Colors.blue;
        break;
      case 'news':
        return Colors.redAccent;
        break;
      default:
        return Colors.grey;
        break;
    }
  }

  /// http://xuongann.com/api/flutter/notifications?kind=$kind
  Future<List<InApp>> loadInAppNotification(String kind,
      {page = 1, pageSize = 20}) async {
    try {
      var url = Core.domain;
      if (Utility.isNullOrEmpty(kind) || kind == 'all') {
        url += 'api/flutter/notifications?pageNumber=$page&pageSize=$pageSize';
      } else {
        url +=
            'api/flutter/notifications?kind=$kind&pageNumber=$page&pageSize=$pageSize';
      }
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        if (Utility.isNullOrEmpty(message)) {
          return [];
        } else {
          List<InApp> _data = new List();
          message.forEach((v) {
            _data.add(new InApp.fromJson(v));
          });
          return _data;
        }
      }
    } catch (e) {
      logging.logError('API - Notification', e);
    }
    return null;
  }
}
