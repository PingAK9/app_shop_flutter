import 'package:shop_flutter/core/app_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlContent extends StatelessWidget {
  final String strHTML;

  HtmlContent(this.strHTML);

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      this.strHTML,
      webView: true,
      textStyle: new TextStyle(fontSize: 16),
      onTapUrl: (url) => {
        AppAction.instance.linkToWebView(context, url, 'Test')
      }
    );
  }
}
