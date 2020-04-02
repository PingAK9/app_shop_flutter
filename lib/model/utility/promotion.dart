class Promotion {
  String code;
  String name;
  String startDate;
  String endDate;

  Promotion({this.code, this.name, this.startDate, this.endDate});

  Promotion.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}
