class Coupon {
  String code;
  double value;
  String startDate;
  String endDate;

  Coupon({this.code, this.value, this.startDate, this.endDate});

  Coupon.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    value = json['value'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['value'] = this.value;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}