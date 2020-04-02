class ProductRelated {
  int id;
  String name;
  String sku;
  String avatar;
  int badge;

  ProductRelated({this.id, this.name, this.sku, this.avatar, this.badge});

  ProductRelated.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    avatar = json['avatar'];
    badge = json['badge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['avatar'] = this.avatar;
    data['badge'] = this.badge;
    return data;
  }
}