import 'package:flutter/material.dart';

class ConfigProvider with ChangeNotifier {
  ConfigProvider() {
    _view = ViewType.grid;
  }

  int _view;

  int get view => _view;

  set view(int view) {
    _view = view;
    notifyListeners();
  }

  forceUpdate(){
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ViewType {
  static const list = 0;
  static const grid = 1;
  static const big = 2;
}
