import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/ui/product_ui/button_download.dart';
import 'package:shop_flutter/ui/utility/app_image.dart';
import 'package:shop_flutter/ui/button/close_button.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';

class ImageView extends StatefulWidget {
  ImageView(this.data);

  final data;

  @override
  _ImageViewState createState() => _ImageViewState(data['url'], data['tag']);
}

class _ImageViewState extends State<ImageView> {
  _ImageViewState(this.url, this.tag);

  var url;
  var tag;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: GestureZoomBox(
                child: Hero(
                  tag: tag,
                  child: AppImage(
                    Core.domain + url,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 15,
              top: 15,
              child: MyCloseButton(onPressed: () {
                Navigator.pop(context);
              }),
            ),
            ButtonDownload(
              imageName:  url,
              cache: true,
            ),
          ],
        ),
      ),
    );
  }
}
