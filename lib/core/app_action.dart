import 'package:shop_flutter/model/product/category.dart';
import 'package:shop_flutter/model/product/product_filter.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/src/models/pages/root_pages/root_page_navigation_bar.dart';
import 'package:shop_flutter/src/providers/roots/root_page_provider.dart';
import 'package:shop_flutter/view/list_product/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppAction {
  factory AppAction() => instance;

  AppAction._internal() {
    alreadySpam = false;
  }

  static final AppAction instance = AppAction._internal();

  bool alreadySpam;

  void onHandleActionInit(
      BuildContext context, String action, String value, String message) {
    if (alreadySpam == false) {
      alreadySpam = true;
      onHandleAction(context, action, value, message);
    }
  }

  void onHandleAction(
      BuildContext context, String action, String value, String message) {
    final _value = value.trim();
    switch (action) {
      case ActionType.linkToCategory:
        linkToCategory(context, _value, message);
        break;
      case ActionType.linkToTag:
        linkToTag(context, _value, message);
        break;
      case ActionType.linkToProduct:
        linkToProductDetail(context, _value);
        break;
      case ActionType.linkToScreen:
        linkToScreen(context, _value, message);
        break;
      case ActionType.linkToWebView:
        linkToWebView(context, _value, message);
        break;
      case ActionType.linkToBrowser:
        linkToWebPage(context, _value);
        break;
      case ActionType.linkToViewMore:
        linkToViewMore(context, _value);
        break;
      default:
        break;
    }
  }

  void linkToProductDetail(BuildContext context, String value) {
    Routes.showProductDetail(context, slug: value);
  }

  void linkToCategory(BuildContext context, String value, String message) {
    ListProduct.showByCategory(context,
        Category(name: message, filter: ProductFilter(categorySlug: value)));
  }

  void linkToTag(BuildContext context, String value, String message) {
    ListProduct.showByCategory(context,
        Category(name: message, filter: ProductFilter(tagSlug: value)));
  }

  void linkToSearch(BuildContext context, String value, String message) {
    ListProduct.showBySearch(
      context,
      Category(
        name: value,
        filter: ProductFilter(productSearch: value),
      ),
    );
  }

  void linkToWebPage(BuildContext context, String value) {
    launch(value);
  }

  void linkToWebView(BuildContext context, String value, String message) {
    Navigator.pushNamed(context, 'page/browser',
        arguments: {'url': value, 'title': message});
  }

  void linkToScreen(BuildContext context, String value, String message) {
    var index = -1;
    switch (value) {
      case 'home':
        index = RootPageNavigationBar.home;
        break;
      case 'category':
        index = RootPageNavigationBar.category;
        break;
      case 'search':
        index = RootPageNavigationBar.search;
        break;
      case 'inapp':
        index = RootPageNavigationBar.notification;
        break;
      case 'user':
        index = RootPageNavigationBar.user;
        break;
      default:
        Navigator.pushNamed(context, '/$value', arguments: message);
        return;
        break;
    }
    if (index >= 0) {
      Provider.of<RootPageProvider>(context, listen: false).navigate(index);
      Navigator.popUntil(context, ModalRoute.withName('home'));
    }
  }

  void linkToViewMore(BuildContext context, String value) {
    Navigator.pushNamed(context, 'page/html', arguments: value);
  }
}

class ActionType {
  static const String linkToProduct = "product";
  static const String linkToCategory = "category";
  static const String linkToTag = "product_tag";
  static const String linkToSearch = "product_search";
  static const String linkToBrowser = "open_browser";
  static const String linkToWebView = "show_web";
  static const String linkToScreen = "go_to_screen";
  static const String linkToViewMore = "view_more";
}
