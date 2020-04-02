import 'package:shop_flutter/model/utility/in_app.dart';
import 'package:shop_flutter/provider/response_provider.dart';
import 'package:shop_flutter/repository/inapp_repository.dart';
import 'package:flutter/material.dart';

class InAppProvider extends ChangeNotifier {
  InAppProvider() {
    mapInApp = new Map();
    for (var item in InAppRepository.instance.categories) {
      getByCategory(item);
    }
  }

  String _currentCategory;

  String get currentCategory => _currentCategory;

  set currentCategory(String currentCategory) {
    _currentCategory = currentCategory;
    notifyListeners();
  }

  // cache for first page
  Map<String, ResponseProvider<List<InApp>>> mapInApp;

  ResponseProvider<List<InApp>> getByCategory(String name) {
    return mapInApp[name];
  }

  loadCoverInApp(String kind) async {
    var inApp = mapInApp[kind];
    try {
      inApp.loading = 'try load';
      notifyListeners();
      List<InApp> data =
          await InAppRepository.instance.loadInAppNotification(kind);
      if (data != null) {
        inApp.completed = data;
      } else {
        inApp.completed = [];
      }
    } catch (e) {
      print(e);
      inApp.error = 'exception: ' + e.toString();
    }
    notifyListeners();
  }
}
