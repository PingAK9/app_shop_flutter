class InApp {
  int id;
  String kind;
  String name;
  String image;
  String action;
  String actionValue;
  String message;
  String createdDate;

  InApp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kind = json['kind'] ?? 'news';
    name = json['name'] ?? '';
    image = json['image'];
    action = json['action'];
    actionValue = json['actionValue'];
    message = json['message'] ?? '';
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['kind'] = this.kind;
    data['action'] = this.action;
    data['actionValue'] = this.actionValue;
    data['message'] = this.message;
    data['createdDate'] = this.createdDate;
    return data;
  }
}