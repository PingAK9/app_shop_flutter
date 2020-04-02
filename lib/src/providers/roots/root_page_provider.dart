import 'package:flutter/material.dart';

class RootPageProvider extends ChangeNotifier {
  // region Parameters
  int _selectedPage = 0;

  // endregion

  // region Getter
  int get selectedPage => _selectedPage;

  // endregion

  RootPageProvider();

  navigate(int index) {
    _selectedPage = index;
    notifyListeners();
  }
}
