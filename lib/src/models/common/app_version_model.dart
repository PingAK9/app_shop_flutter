class AppVersionModel {
  String android;
  String ios;

  AppVersionModel.formJson(Map<String, dynamic> json) {
    this.android = json['android'];
    this.ios = json['ios'];
  }
}
