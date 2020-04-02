class NoLoginInfo {

  int viewProduct;
  int searchProduct;
  bool get canViewProduct => viewProduct < 20;
  bool get canSearchProduct => searchProduct < 20;

  NoLoginInfo({this.viewProduct = 0, this.searchProduct = 0});

  NoLoginInfo.fromJson(Map<String, dynamic> json) {
    viewProduct = json['view_product'];
    searchProduct = json['search_product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['view_product'] = this.viewProduct;
    data['search_product'] = this.searchProduct;
    return data;
  }
}