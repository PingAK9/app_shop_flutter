import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:shop_flutter/core/app_icons.dart';
import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/src/controllers/common/permission_controller.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:shop_flutter/ui/utility/app_image.dart';
import 'package:shop_flutter/ui/utility/app_popup.dart';
import 'package:shop_flutter/ui/utility/app_snackbar.dart';
import 'package:shop_flutter/ui/utility/ask_login.dart';
import 'package:shop_flutter/view/utility/fix_viewinsets_bottom.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';

class SharePage extends StatefulWidget {
  // region Parameters
  final Map data;

  // endregion

  const SharePage(this.data);

  @override
  _SharePageState createState() =>
      _SharePageState(data['images'], data['message'], data['title']);
}

class _SharePageState extends State<SharePage> {
  // region Parameters
  final List<String> images;
  final String message;
  final String title;

  // Max Image for posting the Facebook
  final int limit = 30;

  int maxImage;
  List<String> imagesSelected;

  // endregion

  _SharePageState(this.images, this.message, this.title);

  @override
  void initState() {
    super.initState();

    // region init Parameters
    maxImage = min(limit, images.length);
    imagesSelected = [];

    for (int i = 0; i < images.length && i < maxImage; i++) {
      imagesSelected.add(images[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomAppBar(context),
      ),
    );
  }

  // region build the page
  // Create AppBar
  AppBar _buildAppBar(BuildContext context) {
    if (images == null || images.length == 0) {
      return AppBar(
          leading: IconButton(
            icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Đăng bài viết'));
    }

    return new AppBar(
      leading: IconButton(
        icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
        onPressed: () {
          if (MediaQuery.of(context).viewInsets.bottom > 100) {
            Navigator.pop(context);
            showDialog(context: context, child: FixViewInsetsBottom());
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        'Đã chọn ${imagesSelected.length}/$maxImage hình',
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Bỏ chọn',
            style: TextStyle(color: ANNColor.white),
          ),
          onPressed: () => setState(() => imagesSelected = []),
        )
      ],
    );
  }

  // Create Body
  Widget _buildBody(BuildContext context) {
    if (images == null || images.length == 0) {
      var message = '';

      message += 'Bài viết hoặc sản phẩm không có hình.\n';
      message += 'Hãy chọn đăng Facebook/Zalo như bình thường.';

      return Center(child: Text(message, textAlign: TextAlign.center));
    }

    return new SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildImage(context, images[index]),
                childCount: images.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Create Bottom App Bar
  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return new BottomAppBar(
        color: ANNColor.white,
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  child: FlatButton(
                    child: Row(
                      children: <Widget>[
                        const Text('Đăng Facebook '),
                        Icon(
                          AppIcons.facebook_official,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    onPressed: () => _onClickShareFacebook(context),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: ANNColor.dividerColor,
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Đăng Zalo '),
                      Container(
                        width: 20,
                        height: 20,
                        child: Image.asset('assets/images/ui/zalo-logo.png'),
                      )
                    ],
                  ),
                  onPressed: () => _onClickShareZalo(context),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildImage(BuildContext context, String url) {
    final bool isSelected = imagesSelected.contains(url);
    final double opacity = isSelected ? 1.0 : 0.7;

    final imageWidget = InkWell(
      onTap: () => setState(() => _onClickImage(isSelected, url)),
      child: Opacity(
        opacity: opacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: AppImage(
            Core.domain + url,
          ),
        ),
      ),
    );

    final imageSelectedWidget = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        imageWidget,
        Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(
                  color: ANNColor.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 18, color: ANNColor.white),
            ))
      ],
    );

    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: ANNColor.white,
      ),
      child: isSelected ? imageSelectedWidget : imageWidget,
    );
  }

  // Handle to select the image
  void _onClickImage(bool isSelected, String url) {
    if (isSelected) {
      imagesSelected.remove(url);
    } else {
      if (imagesSelected.length >= maxImage) {
        AppSnackBar.showFlushbar(
            context, 'Chỉ được chọn tối đa $maxImage hình');
      } else {
        imagesSelected.add(url);
      }
    }
  }

  /// Facebook chỉ hổ trợ share image and hashtag
  /// 2. Trao quyền kiểm soát cho mọi người
  /// https://developers.facebook.com/policy/#control
  void _onClickShareFacebook(BuildContext context) {
    if (AccountController.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }

    if (images == null || images.length == 0)
      _onShareMessageOnly(context, message: message);
    else
      _onShare(context, message: message);
  }

  /// Zalo
  /// Android: share nội dung image và content quảng cáo
  /// 1) Nội dụng lưu trong ClipBoard
  /// 2) Hình ảnh sẽ download về "Bộ sư tập"
  ///
  /// IOS:
  /// 1) Hổ trợ share nội dung 1 image và content quảng cáo
  /// 2) Hổ trợ share tối đa 9 image
  void _onClickShareZalo(BuildContext context) {
    if (AccountController.instance.isLogin == false) {
      AskLogin.show(context);
      return;
    }

    if (images == null || images.length == 0) {
      _onShareMessageOnly(context, message: message);
      return;
    }

    final maxForZalo = 9;

    if (Platform.isIOS && imagesSelected.length > maxForZalo) {
      AppPopup.showCustomDialog(
        context,
        content: [
          AvatarGlow(
            endRadius: 50,
            duration: const Duration(milliseconds: 1000),
            glowColor: Colors.blue,
            child: SizedBox(
                height: 50,
                child: Image.asset('assets/images/ui/zalo-logo.png')),
          ),
          Text(
            'Nếu bạn muốn chia sẽ lên ZALO thì chỉ được chọn tối đa $maxForZalo hình',
            style: Theme.of(context).textTheme.subtitle,
            textAlign: TextAlign.center,
          ),
          CenterButtonPopup(
              normal: ButtonData(
                'Đóng',
              ),
              highlight: ButtonData(
                'Chọn $maxForZalo hình',
                onPressed: () {
                  setState(() {
                    imagesSelected.removeRange(
                        maxForZalo, imagesSelected.length);
                  });
                },
              ))
        ],
      );
    } else {
      _onShare(context, message: message, fixZalo: true);
    }
  }

  _onShareMessageOnly(BuildContext context, {String message}) async {
    Share.text(title, message, 'text/plain');
  }

  Future _onShare(BuildContext context, {message, fixZalo = false}) async {
    if (imagesSelected == null || imagesSelected.length == 0) {
      AppSnackBar.showFlushbar(context, 'Bạn chưa chọn hình nào',
          duration: const Duration(seconds: 1));
      return;
    }

    final permission = PermissionController.instance;
    final permissionGroup =
        Platform.isAndroid ? PermissionGroup.storage : PermissionGroup.photos;
    final checkPermission =
        await permission.checkAndRequestPermission(context, permissionGroup);

    if (!checkPermission) return;

    final List<String> files = [];
    final Map<String, List<int>> mapByte = {};
    final loadingDialog = new LoadingDialog(context, message: 'Đang tải...');

    loadingDialog.show();
    // TODO: At share in the product, the clipboard is double copy
    await Clipboard.setData(new ClipboardData(text: message));

    for (int i = 0; i < imagesSelected.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      await DefaultCacheManager()
          .getSingleFile(Core.domain + imagesSelected[i])
          .then((File file) {
        files.add(file.path);
        mapByte['image_$i.png'] = file.readAsBytesSync();
        if (Platform.isAndroid && fixZalo)
          ImageGallerySaver.saveImage(mapByte['image_$i.png'])
              .catchError((e) => print(e));
        loadingDialog.message = 'Đã tải ${i + 1}/${imagesSelected.length} hình';
      }).catchError((e) => print(e));
    }
    loadingDialog.close();

    if (files.length == 0) {
      AppSnackBar.showFlushbar(context, 'Tải hình thất bại',
          duration: const Duration(seconds: 1));
      return;
    }

    if (Platform.isAndroid) {
      if (fixZalo)
        Share.text(title, message, 'text/plain');
      else
        Share.files(title, mapByte, 'image/png', text: message);
    } else if (Platform.isIOS) {
      if (fixZalo) {
        if (files.length == 1) {
          final imageName = mapByte.keys.first;
          final imageByte = mapByte[imageName];

          Share.file(title, imageName, imageByte, "image/png", text: message);
        } else {
          ShareExtend.shareMultiple(files, "image");
        }
      } else {
        Share.files(title, mapByte, 'image/png', text: message);
      }
    } else {
      return;
    }
  }
}
