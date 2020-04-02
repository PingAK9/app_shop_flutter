class Noti {
  String id;

  String status;

  String message;

  String title;

  String value;

  String type;

  String date;

  Noti(
      {this.id,
      this.status,
      this.message,
      this.title,
      this.value,
      this.type,
      this.date});

  factory Noti.fromMap(Map data) {
    data = data ?? {};
    return Noti(
      id: data['id'].toString() ?? '',
      status: data['status'].toString() ?? '0',
      message: data['message'] ?? '',
      title: data['title'] ?? '',
      value: data['value'] ?? '',
      type: data['type'] ?? '',
      date: data['date'] ?? '',
    );
  }
}
