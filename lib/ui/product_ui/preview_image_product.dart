import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/model/product/product.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/product_ui/button_download.dart';
import 'package:shop_flutter/ui/utility/app_image.dart';
import 'package:shop_flutter/ui/button/close_button.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';

class PreviewImageProduct extends StatefulWidget {
  PreviewImageProduct(this.carousel,
      {this.initIndex = 0, this.controller, this.tapExpanded});

  final List<ProductCarousel> carousel;
  final initIndex;
  final PageController controller;
  final tapExpanded;

  @override
  _PreviewImageProductState createState() => _PreviewImageProductState();
}

class _PreviewImageProductState extends State<PreviewImageProduct> {
  List<ProductCarousel> carousel;
  PageController controller;
  VoidCallback tapExpanded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _indexImage = widget.initIndex;
    carousel = widget.carousel;
    tapExpanded = widget.tapExpanded;
    controller =
        widget.controller ?? new PageController(initialPage: indexImage);
    thumbnailController =
        ScrollController(initialScrollOffset: getOffsetByIndex(_indexImage));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: tapExpanded,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                PageView.builder(
                    itemCount: carousel.length,
                    controller: controller,
                    onPageChanged: (index) {
                      indexImage = index;
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        child: GestureZoomBox(
                          child: AppImage(
                            Core.domain +
                                (tapExpanded != null
                                    ? carousel[index].feature
                                    : carousel[index].origin),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }),
                Container(
                  child: tapExpanded == null
                      ? Positioned(
                          right: 15,
                          top: 15,
                          child: MyCloseButton(onPressed: () {
                            Navigator.pop(context, indexImage);
                          }),
                        )
                      : Positioned(
                          right: 10,
                          top: 10,
                          child: Icon(
                            Icons.zoom_out_map,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                ),
                ButtonDownload(
                  imageName: carousel[indexImage].origin,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildImageSelect(carousel)
      ],
    );
  }

  int _indexImage = 0;

  int get indexImage => _indexImage;

  set indexImage(int indexImage) {
    thumbnailController.animateTo(getOffsetByIndex(indexImage),
        duration: Duration(milliseconds: 500), curve: Curves.linear);
    setState(() {
      _indexImage = indexImage;
    });
  }

  double getOffsetByIndex(indexImage) {
    double _offset = 0;
    if (indexImage >= 4) {
      _offset = (indexImage - 3) * 75.0;
    }
    return _offset;
  }

  ScrollController thumbnailController;

  Widget _buildImageSelect(List<ProductCarousel> images) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        controller: thumbnailController,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 2,
        itemBuilder: (context, index) {
          if (index == (images.length + 1) || index == 0) {
            return SizedBox(
              width: defaultPadding,
            );
          } else {
            return _imageButton(images[index - 1].thumbnail, index: index - 1);
          }
        },
      ),
    );
  }

  Widget _imageButton(String url, {index = 0}) {
    bool isSelect = indexImage == index;
    return Container(
      width: 55,
      decoration: BoxDecoration(
        color: ANNColor.white,
        border: isSelect
            ? new Border.all(
                color: Theme.of(context).primaryColor,
                width: 1.5,
                style: BorderStyle.solid,
              )
            : null,
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          controller.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        },
        child: Opacity(
          opacity: isSelect ? 1 : 0.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: AppImage(
              Core.domain + url,
              showLoading: false,
            ),
          ),
        ),
      ),
    );
  }
}
