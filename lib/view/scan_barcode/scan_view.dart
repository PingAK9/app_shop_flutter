import 'dart:async';
import 'dart:math';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/product/category.dart';
import 'package:shop_flutter/model/product/product_filter.dart';
import 'package:shop_flutter/provider/utility/search_provider.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/ui/button/close_button.dart';
import 'package:shop_flutter/view/list_product/list_product.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanView extends StatefulWidget {
  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView>
    with SingleTickerProviderStateMixin {
  List<CameraDescription> cameras;
  QRReaderController controllerQR;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AnimationController animationController;
  Animation<double> animation;

  final _barcodeTextController = TextEditingController();

  bool flashOn = false;
  bool bottomSheetIsOpen = true;
  double squareSize = 250;

  Future loadCamera() async {
    try {
      cameras = await availableCameras();
    } on QRReaderException catch (e) {
      print(e);
    }
    initCameraView();
  }

  @override
  void dispose() {
    controllerQR?.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      bottomSheetIsOpen = false;
      loadCamera();
    });

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0.1, end: 0.9).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  _openResultView(dynamic value) async {
    if (controllerQR != null) {
      flashOn = false;
      controllerQR.dispose();
    }
//    var products = await ListProductRepository.instance.loadBySku(value);
//    if (Utility.isNullOrEmpty(products) == false) {
//      if (products.length == 1) {
//        await Router.showProductDetail(context, product: products[0]);
//      } else {
//        await ListProduct.showByCategory(context,
//            Category(name: value, filter: ProductFilter(productSKU: value)),
//            initData: products, showSearch: true);
//      }
//    } else {
//      AppSnackBar.showFlushbar(context, 'Không tìm thấy sản phẩm $value');
//      await Future.delayed(Duration(milliseconds: 500));
//    }
    Provider.of<SearchProvider>(context, listen: false).addHistory(value);
    await ListProduct.showByCategory(context,
        Category(name: value, filter: ProductFilter(productSKU: value)),
        initData: null, showSearch: true);

    bottomSheetIsOpen = false;
    initCameraView();
  }

  void initCameraView() {
    if (bottomSheetIsOpen == false) {
      controllerQR = QRReaderController(cameras[0], ResolutionPreset.high, [
        CodeFormat.code128,
        CodeFormat.code39,
        CodeFormat.codabar,
        CodeFormat.upca,
        CodeFormat.ean13,
        CodeFormat.upce,
        CodeFormat.ean8
      ], (value) {
        flashOn = false;
        controllerQR.stopScanning();
        if (!bottomSheetIsOpen) {
          _openResultView(value);
        }
      });

      controllerQR.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
        controllerQR.startScanning();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    squareSize = min(270, size.width);
    bool hasKeyboard = MediaQuery.of(context).viewInsets.bottom > 100;
    List<Widget> _children = [_buildCamera()];

    if (hasKeyboard == false) {
      _children.add(
        Align(
          alignment: Alignment(0.0, 0.2),
          child: Container(
            width: squareSize,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTitle(
                    'Điều chỉnh camera để mã vạch nằm trong ô vuông bên dưới'),
                Container(
                  width: squareSize,
                  height: squareSize,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ANNColor.white)),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: AnimatedBuilder(
                          animation: animationController,
                          child: SizedBox(
                            width: squareSize,
                            child: Container(
                              height: 1,
                              color: Colors.redAccent,
                            ),
                          ),
                          builder: (BuildContext context, Widget _widget) {
                            return Transform.translate(
                              offset: Offset(0, animation.value * squareSize),
                              child: _widget,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                _buildTitle('Mã vạch sẽ được quét tự động'),
                IconButton(
                  onPressed: () => _turnFlash(),
                  icon: Icon(
                    flashOn ? Icons.flash_off : Icons.flash_on,
                    size: 30,
                    color: ANNColor.white,
                  ),
                ),
                InkWell(
                  onTap: _showInputCode,
                  child: Container(
                    width: squareSize,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: ANNColor.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Nhập mã vạch bằng tay',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: Icon(
                            Icons.keyboard_backspace,
                            textDirection: TextDirection.rtl,
                            color: ANNColor.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    _children.add(Positioned(
      top: 30,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 60,
            child: MyCloseButton(
              onPressed: () {
                if (flashOn) {
                  _turnFlash();
                }
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Quét mã vạch sản phẩm',
                style: TextStyle(color: ANNColor.white, fontSize: 18),
                maxLines: 1,
              ),
            ),
          ),
          Container(
            width: 60,
          ),
        ],
      ),
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Stack(
        overflow: Overflow.clip,
        fit: StackFit.loose,
        children: _children,
      ),
    );
  }

  Widget _buildCamera() {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / (size.height);
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Container(
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Transform.scale(
                scale:
                    (controllerQR != null && controllerQR.value.isInitialized)
                        ? deviceRatio > controllerQR.value.aspectRatio
                            ? deviceRatio / controllerQR.value.aspectRatio
                            : controllerQR.value.aspectRatio / deviceRatio
                        : 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: _cameraPreviewWidget(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildTitle(text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle.merge(
              TextStyle(color: ANNColor.white),
            ),
      ),
    );
  }

  _showInputCode() {
    bottomSheetIsOpen = true;
    if (controllerQR != null) {
      flashOn = false;
      controllerQR.dispose();
      controllerQR = null;
    }
    persistentBottomSheetController().closed.then(_closeBottomSheet);
  }

  String _valueInput;

  _closeBottomSheet(value) {
    bottomSheetIsOpen = false;
    if (Utility.isNullOrEmpty(_valueInput)) {
      initCameraView();
    } else {
      _openResultView(_valueInput);
    }
  }

  PersistentBottomSheetController persistentBottomSheetController() {
    _barcodeTextController.text = "";
    _valueInput = '';
    return _scaffoldKey.currentState.showBottomSheet(
      (context) {
        return Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
              color: ANNColor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 24),
                  Text(
                    'Nhập mã sản phẩm',
                    style: Theme.of(context).textTheme.title,
                  ),
                  const CloseButton(),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _barcodeTextController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Nhập mã sản phẩm',
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                  style: BorderStyle.solid)),
                        ),
                        onFieldSubmitted: (value) {
                          _valueInput = _barcodeTextController.text;
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      width: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _valueInput = _barcodeTextController.text;
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.keyboard_backspace,
                          textDirection: TextDirection.rtl,
                          color: ANNColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controllerQR == null || !controllerQR.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    } else {
      return AspectRatio(
        aspectRatio: controllerQR.value.aspectRatio,
        child: QRReaderPreview(controllerQR),
      );
    }
  }

  _turnFlash() async {
    controllerQR.toggleFlash();
    setState(() {
      flashOn = !flashOn;
    });
  }
}
