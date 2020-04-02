class WebViewQueryParameterModel {
  final String url;

  const WebViewQueryParameterModel(this.url);

  WebViewQueryParameterModel.fromJson(Map<String, dynamic> json)
      : url = json['url'];

  Map<String, dynamic> toJson() => {'url': url};
}
