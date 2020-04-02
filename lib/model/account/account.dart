class Account {
  int id;
  String phone;
  String password;
  String fullName;
  String birthDay;
  String gender;
  String address;
  String city;

  Account(
      {this.id,
      this.phone,
      this.password,
      this.fullName,
      this.birthDay,
      this.gender,
      this.address,
      this.city});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    password = json['password'] ?? '';
    fullName = json['fullName'];
    birthDay = json['birthDay'];
    gender = json['gender'];
    address = json['address'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['fullName'] = this.fullName;
    data['birthDay'] = this.birthDay;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['city'] = this.city;
    return data;
  }
}
