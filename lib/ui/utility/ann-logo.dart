import 'package:shop_flutter/core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnnLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: null,
      imageUrl: Core.annLogoWithLink,
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/ui/ann-com.png',
        fit: BoxFit.contain,
      ),
      fit: BoxFit.contain,
    );
  }
}
