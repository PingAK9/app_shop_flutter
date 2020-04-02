import 'dart:convert';

import 'package:shop_flutter/core/storage_manager.dart';
import 'package:shop_flutter/model/account/account.dart';
import 'package:shop_flutter/model/account/account_token.dart';
import 'package:shop_flutter/model/account/no_login_info.dart';

class AccountController {
  static final AccountController instance = AccountController._internal();

  factory AccountController() => instance;

  AccountController._internal() {
    /// init
  }

  Account account;
  AccountToken token;
  NoLoginInfo noLoginInfo;

  bool get isLogin => token != null;

  bool get canViewProduct {
    if (isLogin) {
      return true;
    }
    if (noLoginInfo.canViewProduct) {
      noLoginInfo.viewProduct++;
      StorageManager.setObject(
          _keyNoLoginInfo, json.encode(noLoginInfo.toJson()));
      return true;
    }
    return false;
  }

  bool get canSearchProduct {
    if (isLogin) {
      return true;
    }
    if (noLoginInfo.canSearchProduct) {
      noLoginInfo.searchProduct++;
      StorageManager.setObject(
          _keyNoLoginInfo, json.encode(noLoginInfo.toJson()));
      return true;
    }
    return false;
  }

  Map<String, String> get header => {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + (token == null ? '' : token.accessToken)
      };

  finishLogin(Map response, String password) {
    account = Account.fromJson(response['user']);
    token = AccountToken.fromJson(response['token']);

    account.password = password;
    StorageManager.clearObjectByKey(_keyAccount);
    StorageManager.setObject(_keyAccount, json.encode(account.toJson()));
    StorageManager.clearObjectByKey(_keyToken);
    StorageManager.setObject(_keyToken, json.encode(token.toJson()));
  }

  void logout() {
    token = null;
    StorageManager.clearObjectByKey(_keyToken);
  }

  final _keyAccount = '_keyAccount';
  final _keyToken = '_keyToken';
  final _keyNoLoginInfo = '_keyNoLoginInfo';

  updateAccountInfo(Account _account) {
    this.account = _account;
    StorageManager.clearObjectByKey(_keyAccount);
    StorageManager.setObject(_keyAccount, json.encode(account.toJson()));
  }

  loadFormLocale() async {
    try {
      var userResponse = await StorageManager.getObjectByKey(_keyAccount);
      if (userResponse != null) {
        account = Account.fromJson(jsonDecode(userResponse));
      }

      // Fix bug: Token expires
      token = null;
      StorageManager.clearObjectByKey(_keyToken);
    } catch (e) {
      print(e);
    }
  }
}
