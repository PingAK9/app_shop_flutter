import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/model/product/product_detail.dart';
import 'package:shop_flutter/repository/product_repository.dart';
import 'package:shop_flutter/ui/product_ui/preview_image_product.dart';
import 'package:flutter/material.dart';

class ProductImageBySizeAndColor extends StatefulWidget {
  ProductImageBySizeAndColor(this.data);

  final Map data;

  @override
  _ProductImageBySizeAndColorState createState() =>
      _ProductImageBySizeAndColorState();
}

class _ProductImageBySizeAndColorState
    extends State<ProductImageBySizeAndColor> {
  List<ProductCarousel> carousel;
  ProductDetail detail;
  PageController controller;
  int currentSize;
  int currentColor;

  bool isLoading;

  loadingAPI() async {
    if (currentSize > 0 || currentColor > 0) {
      setState(() {
        isLoading = true;
      });
      String image = await ProductRepository.instance
          .loadProductImageSize(detail.productID, currentColor, currentSize);
      setState(() {
        isLoading = false;
        if (Utility.isNullOrEmpty(image) == false) {
          int index = indexOf(image);
          if (index >= 0) {
            animationToPage(index);
          }
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  indexOf(String url) {
    for (int i = 0; i < carousel.length; i++) {
      if (carousel[i].origin == url) {
        return i;
      }
    }
    return -1;
  }

  animationToPage(index) {
    controller.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _indexImage = widget.data['index'] ?? 0;
    detail = widget.data['data'];
    carousel = detail.carousel;
    currentSize = 0;
    currentColor = 0;
    controller = new PageController(initialPage: _indexImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2 + 80,
              child: PreviewImageProduct(
                detail.carousel,
                controller: controller,
                initIndex: _indexImage,
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView(
                children: <Widget>[
                  _buildSizesSelect(),
                  _buildColorsSelect(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  int _indexImage = 0;

  double getOffsetByIndex(indexImage) {
    double _offset = 0;
    if (indexImage >= 4) {
      _offset = (indexImage - 3) * 75.0;
    }
    return _offset;
  }

  Widget _buildColorsSelect() {
    if (Utility.isNullOrEmpty(detail.colors)) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(defaultPadding, 15, defaultPadding, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle('Chọn màu:'),
            Wrap(
              children:
                  detail.colors.map((item) => _buildChipColor(item)).toList(),
            )
          ],
        ),
      );
    }
  }

  Widget _buildSizesSelect() {
    if (Utility.isNullOrEmpty(detail.sizes)) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(defaultPadding, 15, defaultPadding, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitle('Chọn size:'),
            Wrap(
              children:
                  detail.sizes.map((item) => _buildChipSize(item)).toList(),
            )
          ],
        ),
      );
    }
  }

  Widget _buildTitle(name) {
    return Text(
      name,
      style: Theme.of(context).textTheme.subtitle,
    );
  }

  Widget _buildChipSize(ProductSize item) {
    return Container(
        margin: EdgeInsets.only(left: 10),
        child: ChoiceChip(
          label: Text(item.name),
          selected: item.id == currentSize,
          onSelected: (value) {
            currentSize = value ? item.id : 0;
            loadingAPI();
          },
        ));
  }

  Widget _buildChipColor(ProductColor item) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: ChoiceChip(
        label: Text(item.name),
        selected: item.id == currentColor,
        onSelected: (value) {
          currentColor = value ? item.id : 0;
          loadingAPI();
        },
      ),
    );
  }
}
