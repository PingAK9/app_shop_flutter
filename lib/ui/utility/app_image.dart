import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  AppImage(this.url, {this.fit = BoxFit.cover, this.showLoading = true});

  final String url;
  final BoxFit fit;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return _buildCachedImage();
  }

  _buildCachedImage() {
    var fullUrl = url.contains('http') ? url : (Core.domain + url);
    return CachedNetworkImage(
      imageUrl: fullUrl,
      fit: fit,
      placeholder: showLoading
          ? (context, url) {
              return Center(
                child: Indicator(),
              );
            }
          : null,
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
