import 'dart:io';

import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:http/http.dart' as http;

appGet(String url) async {
  try {
    final response = await http
        .get(url, headers: AccountController.instance.header)
        .timeout(Duration(seconds: 10));
    if (response.statusCode == HttpStatus.unauthorized) {
    } else {
      return response;
    }
  } catch (e) {
    throw (e);
  }
  throw ('Some thing went wrong');
}

appPost(String url, {var body}) async {
  try {
    final response = await http
        .post(url, body: body, headers: AccountController.instance.header)
        .timeout(Duration(seconds: 10));
    if (response.statusCode == HttpStatus.unauthorized) {
    } else {
      return response;
    }
  } catch (e) {
    throw (e);
  }
  throw ('Some thing went wrong');
}
