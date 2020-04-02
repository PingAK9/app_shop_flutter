import 'package:shop_flutter/core/utility.dart';

class CopySetting {
  bool productCode;
  bool productName;
  int bonusPrice;
  String phoneNumber;
  String address;
  bool showed;

  String getUserInfo() {
    String _value = '';
    if (Utility.isNullOrEmpty(phoneNumber) == false) {
      _value += '\n⭐SDT: $phoneNumber';
    }
    if (Utility.isNullOrEmpty(address) == false) {
      _value += '\n⭐Địa chỉ: $address';
    }
    return _value;
  }

  CopySetting(
      {this.productCode = true,
      this.productName = true,
      this.bonusPrice = 50000,
      this.phoneNumber = '',
      this.address = '',
      this.showed = false});

  CopySetting.fromJson(Map<String, dynamic> json) {
    productCode = json['productCode'];
    productName = json['productName'];
    bonusPrice = json['bonusPrice'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    showed = json['showed']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productCode'] = this.productCode;
    data['productName'] = this.productName;
    data['bonusPrice'] = this.bonusPrice;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['showed'] = this.showed;
    return data;
  }
}
