import 'dart:convert';
import 'dart:io';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/model/account/account.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/repository/app_response.dart';
import 'package:http/http.dart' as http;

class AccountRepository {
  static final AccountRepository instance = AccountRepository._internal();

  factory AccountRepository() => instance;

  AccountRepository._internal() {
    // todo
  }

  Future<AppResponse> checkPhoneNumber(String phone) async {
    try {
      final url = '${Core.domain}api/flutter/user/check?phone=$phone';
      final response = await http.get(url);

      if (response.statusCode == HttpStatus.ok) {
        Map parsed = jsonDecode(response.body);
        var result = parsed['exists'];
        return AppResponse(true, data: result);
      } else {
        return AppResponse(false);
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> registerStep2RequestOTP(String phone, String otp) async {
    try {
      String formatPhone = '84' + phone.substring(1);
      Map data = {"phone": formatPhone, "otp": otp};
      final url = '${Core.domain}api/sms/otp';
      final response = await http.post(url, body: data);

      if (response.statusCode == HttpStatus.ok) {
        return AppResponse(true);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> registerStep3ValidateOTP(String phone, String otp) async {
    try {
      Map data = {"phone": phone, "otp": otp};
      final url = '${Core.domain}api/flutter/user/confirm-otp';
      final response = await http.post(url, body: data);

      if (response.statusCode == HttpStatus.ok) {
        return AppResponse(true);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> registerStep4CreatePassword(
      String phone, String otp, String password) async {
    try {
      Map data = {"phone": phone, 'otp': otp, "passwordNew": password};
      String url = '${Core.domain}api/flutter/user/create-password';
      final response = await http
          .post(
            url,
            body: data,
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> login(String phone, String password) async {
    try {
      Map data = {"phone": phone, "password": password};
      String url = '${Core.domain}api/flutter/user/login';
      final response = await http
          .post(
            url,
            body: data,
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> updateInformation(Account account) async {
    try {
      final url = '${Core.domain}api/flutter/user/update-info';
      final response = await http.patch(
        url,
        body: jsonEncode(account.toJson()),
        headers: AccountController.instance.header,
      );

      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> forgotPasswordByBirthDay(
      String phone, String birthDay) async {
    try {
      String newPass = birthDay.replaceAll('-', '').substring(0, 6);
      Map data = {
        "phone": phone,
        "otp": newPass,
        "birthday": birthDay,
      };
      String url = '${Core.domain}api/flutter/user/password-new-by-birthday';
      final response =
          await http.patch(url, body: data).timeout(Duration(seconds: 10));

      if (response.statusCode == HttpStatus.ok) {
        var parsed = jsonDecode(response.body);
        return AppResponse(true, data: parsed['password']);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  Future<AppResponse> changePassword(String newPassword) async {
    try {
      String url = Core.domain +
          'api/flutter/user/change-password?passwordNew=$newPassword';

      final response = await http
          .patch(
            url,
            headers: AccountController.instance.header,
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == HttpStatus.ok) {
        return AppResponse(true);
      } else {
        return AppResponse(false, message: getMessage(response.body));
      }
    } catch (e) {
      print(e);
    }
    return AppResponse(false);
  }

  String getMessage(body) {
    try {
      Map parsed = jsonDecode(body);
      if (parsed.containsKey('Message')) {
        return parsed['Message'];
      }
      if (parsed.containsKey('ModelState')) {}
    } catch (e) {
      print(e);
    }
    return null;
  }

  final cityOfVietnam = [
    "TP Hồ Chí Minh",
    "An Giang",
    "Bà Rịa – Vũng Tàu",
    "Bắc Giang",
    "Bắc Kạn,",
    "Bạc Liêu",
    "Bắc Ninh",
    "Bến Tre",
    "Bình Định",
    "Bình Dương",
    "Bình Phước",
    "Bình Thuận",
    "Cà Mau",
    "Cần Thơ",
    "Cao Bằng",
    "Đà Nẵng",
    "Đắk Lắk",
    "Đắk Nông",
    "Điện Biên",
    "Đồng Nai",
    "Đồng Tháp",
    "Gia Lai",
    "Hà Giang",
    "Hà Nam",
    "Hà Nội",
    "Hà Tĩnh",
    "Hải Dương",
    "Hải Phòng",
    "Hậu Giang",
    "Hòa Bình",
    "Hưng Yên",
    "Khánh Hòa",
    "Kiên Giang",
    "Kon Tum",
    "Lai Châu",
    "Lâm Đồng",
    "Lạng Sơn",
    "Lào Cai",
    "Long An",
    "Nam Định",
    "Nghệ An",
    "Ninh Bình",
    "Ninh Thuận",
    "Phú Thọ",
    "Phú Yên",
    "Quảng Bình",
    "Quảng Nam",
    "Quảng Ngãi",
    "Quảng Ninh",
    "Quảng Trị",
    "Sóc Trăng",
    "Sơn La",
    "Tây Ninh",
    "Thái Bình",
    "Thái Nguyên",
    "Thanh Hóa",
    "Thừa Thiên Huế",
    "Tiền Giang",
    "Trà Vinh",
    "Tuyên Quang",
    "Vĩnh Long",
    "Vĩnh Phúc",
    "Yên Bái",
  ];
}
