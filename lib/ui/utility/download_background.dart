import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/provider/utility/download_image_provider.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownLoadBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DownloadImageProvider provider = Provider.of(context);
    String message = provider.currentMessage;

    if (Utility.isNullOrEmpty(message)) {
      return Container(
        height: 0,
      );
    } else {
      return Container(
        height: 24,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Indicator(
              radius: 8,
            ),
            SizedBox(
              width: 10,
            ),
            Text(message),
          ],
        ),
      );
    }
  }
}
