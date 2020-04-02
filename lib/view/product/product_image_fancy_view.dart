import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/model/product/product_detail.dart';
import 'package:shop_flutter/ui/product_ui/preview_image_product.dart';
import 'package:flutter/material.dart';

class ProductImageFancyView extends StatefulWidget {
  ProductImageFancyView(this.data);

  final Map data;

  @override
  _ProductImageFancyViewState createState() => _ProductImageFancyViewState();
}

class _ProductImageFancyViewState extends State<ProductImageFancyView> {
  List<ProductCarousel> carousel;
  ProductDetail detail;
  int _indexImage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _indexImage = widget.data['index'];
    detail = widget.data['data'];
    carousel = detail.carousel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PreviewImageProduct(
          detail.carousel,
          initIndex: _indexImage,
        ),
      ),
    );
  }
}
