import 'dart:typed_data';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/main.dart';
import 'package:shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DownloadImageProvider extends ChangeNotifier {
  List<String> _images;

  List<String> get images => _images;

  Future<bool> downloadImages(List<String> images) async {
    if (_images == null) {
      _images = images;
      if (Utility.isNullOrEmpty(images) == false) {
        countFail = 0;
        _saveImage(0);
      }
      return true;
    }
    return false;
  }

  int index = 0;
  int countFail;

  String get currentMessage =>
      images != null ? 'Đang tải $index/${images.length}' : null;

  _saveImage(_index) async {
    index = _index;
    if (_index >= images.length) {
      AppSnackBar.showHighlightTopMessage(MyApp.context,
          'Tải thành công ${images.length - countFail}/${images.length} hình');
      _images = null;
      notifyListeners();
      return;
    }
    try {
      notifyListeners();
      var file = await DefaultCacheManager()
          .getSingleFile(Core.domain + images[_index])
          .timeout(Duration(seconds: 10));
      Uint8List bytes = file.readAsBytesSync();
      await ImageGallerySaver.saveImage(bytes).timeout(Duration(seconds: 5));
    } catch (e) {
      countFail++;
      print(e);
    }
    _saveImage(_index + 1);
  }
}
