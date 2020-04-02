class Cover {
  String name;
  String message;
  String image;
  String action;
  String actionValue;
  String createdDate;

  Cover({this.image, this.action, this.actionValue, this.name});

  Cover.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    message = json['message'];
    image = json['image'];
    action = json['action'];
    actionValue = json['actionValue'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['message'] = this.message;
    data['image'] = this.image;
    data['action'] = this.action;
    data['actionValue'] = this.actionValue;
    data['createdDate'] = this.createdDate;
    return data;
  }
}