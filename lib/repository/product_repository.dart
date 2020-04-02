import 'dart:convert';
import 'dart:io';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/copy_setting/copy_controller.dart';
import 'package:shop_flutter/model/copy_setting/copy_setting.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/model/product/product_detail.dart';
import 'package:shop_flutter/model/product/product_related.dart';
import 'package:shop_flutter/provider/utility/download_image_provider.dart';
import 'package:shop_flutter/src/controllers/common/permission_controller.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:shop_flutter/ui/utility/app_snackbar.dart';
import 'package:shop_flutter/ui/utility/ask_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ProductRepository {
  factory ProductRepository() => instance;

  ProductRepository._internal() {
    /// init
    productSorts = [
      ProductSort(id: 4, title: 'Mới nhập kho'),
      ProductSort(id: 2, title: 'Giá giảm dần'),
      ProductSort(id: 1, title: 'Giá tăng dần'),
      ProductSort(id: 3, title: 'Mẫu mới nhất'),
    ];

    productBadge = [
      ProductBadge(id: 1, title: 'Hàng có sẵn'),
      ProductBadge(id: 2, title: 'Hết hàng'),
      ProductBadge(id: 3, title: 'Hàng order'),
      ProductBadge(id: 4, title: 'Hàng sale'),
      ProductBadge(id: 5, title: 'Đang nhập kho'),
    ];
  }

  static final ProductRepository instance = ProductRepository._internal();

  List<ProductSort> productSorts;
  List<ProductBadge> productBadge;

  String getBadgeName(badge) {
    switch (badge) {
      case 1:
        return 'Có sẵn';
        break;
      case 2:
        return 'Hết hàng';
        break;
      case 3:
        return 'Order';
        break;
      case 4:
        return 'Sale';
        break;
      case 5:
        return 'Đang nhập kho';
        break;
      default:
        return '';
        break;
    }
  }

  Color getBadgeColor(badge) {
    switch (badge) {
      case 1:
        return ANNColor.orange;
        break;
      case 2:
        return Colors.grey[700];
        break;
      case 3:
        return Colors.purple;
        break;
      case 4:
        return Colors.grey;
        break;
      case 5:
        return const Color(0xfffdc80f);
        break;
      default:
        return null;
        break;
    }
  }

  /// http://xuongann.com/api/flutter/product/ao-thun-nam-ca-sau-adidas
  Future<ProductDetail> loadProductDetail(String slug) async {
    try {
      final url = '${Core.domain}api/flutter/product/$slug';
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == HttpStatus.ok) {
        final message = jsonDecode(response.body);
        return ProductDetail.fromJson(message);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/product/ao-thun-nam-ca-sau-adidas/related
  Future<List<ProductRelated>> loadRelatedOfProduct(String slug,
      {int page = 1, int pageSize = itemPerPage}) async {
    try {
      final url =
          '${Core.domain}api/flutter/product/$slug/related?pageNumber=$page&pageSize=$pageSize';
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == HttpStatus.ok) {
        var message = jsonDecode(response.body);
        final List<ProductRelated> _data = [];
        message.forEach((v) {
          _data.add(ProductRelated.fromJson(v));
        });
        return _data;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/product/1/image?color=10&size=178
  Future<String> loadProductImageSize(int id, int color, int size) async {
    try {
      final url =
          '${Core.domain}api/flutter/product/$id/image?color=$color&size=$size';
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        final message = jsonDecode(response.body);
        return message;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/product/1/advertisement-image
  Future<List<String>> loadProductAdvertisementImage(int id) async {
    try {
      final url = '${Core.domain}api/flutter/product/$id/advertisement-image';
      final response = await http
          .get(url, headers: AccountController.instance.header)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        final message = jsonDecode(response.body);
        return message.cast<String>();
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// http://xuongann.com/api/flutter/product/1/advertisement-content
  Future<String> loadProductAdvertisementContent(int id) async {
    try {
      final CopySetting copySetting = CopyController.instance.copySetting;
      final Map data = {
        "shopPhone": copySetting.phoneNumber,
        "shopAddress": copySetting.address,
        "showSKU": copySetting.productCode,
        "showProductName": copySetting.productName,
        "increntPrice": copySetting.bonusPrice
      };
      final url = '${Core.domain}api/flutter/product/$id/advertisement-content';
      final response = await http
          .post(url,
              headers: AccountController.instance.header,
              body: jsonEncode(data))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == HttpStatus.ok) {
        final result = utf8.decode(response.bodyBytes);
        return result;
      }
    } catch (e) {
      print(e);
    }
    return '';
  }

  /// http://xuongann.com/api/flutter/product-sort
  Future getProductSort() async {
    try {
      final url = '${Core.domain}api/flutter/product-sort';
      await http
          .get(url, headers: AccountController.instance.header)
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print(e);
    }
  }

  Future onCheckAndCopy(BuildContext context, int productID) async {
    if (AccountController.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }
    if (CopyController.instance.copySetting.showed) {
      await onCopy(context, productID);
      AppSnackBar.showFlushbar(
          context, 'Đã copy, hãy dán vào nơi đăng sản phẩm',
          duration: const Duration(seconds: 1));
    } else {
      await Navigator.pushNamed(context, 'user');
    }
  }

  Future<String> onCopy(BuildContext context, int productID) async {
    final result = await ProductRepository.instance
        .loadProductAdvertisementContent(productID);
    await Clipboard.setData(new ClipboardData(text: result));
    return result;
  }

  Future onShare(BuildContext context, Product product) async {
    try {
      final message = await onCopy(context, product.productID);
      final loadingDialog = new LoadingDialog(context, message: 'Đang tải...');

      loadingDialog.show();
      final images = await ProductRepository.instance
          .loadProductAdvertisementImage(product.productID);
      loadingDialog.close();
      if (Utility.isNullOrEmpty(images) == false) {
        await Navigator.pushNamed(context, 'product/detail/share-social',
            arguments: {
              'images': images,
              'title': product.name,
              'message': message
            });
      } else {
        throw ArgumentError('API fail');
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: const Duration(seconds: 1));
      return;
    }
  }

  /// save to gallery
  Future onDownLoad(BuildContext context, int productID) async {
    if (AccountController.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }
    try {
      final images = await ProductRepository.instance
          .loadProductAdvertisementImage(productID);
      if (Utility.isNullOrEmpty(images)) {
        AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
            duration: const Duration(seconds: 1));
      } else {
        final permissionGroup = Platform.isAndroid
            ? PermissionGroup.storage
            : PermissionGroup.photos;
        final permission = await PermissionController.instance
            .checkAndRequestPermission(context, permissionGroup);
        if (permission) {
          final result =
              await Provider.of<DownloadImageProvider>(context, listen: false)
                  .downloadImages(images);
          if (result == false) {
            AppSnackBar.showFlushbar(
                context, 'Đang tải sản phẩm, vui lòng đợi trong giây lát.');
          }
        }
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: const Duration(seconds: 1));
    }
  }
}
