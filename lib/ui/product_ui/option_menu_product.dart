import 'package:shop_flutter/core/app_icons.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/src/models/ann_page.dart';
import 'package:shop_flutter/theme/app_styles.dart';
import 'package:flutter/material.dart';

class OptionMenuProduct extends StatelessWidget {
  // region Parameters
  final VoidCallback onShare;
  final VoidCallback onDownload;
  final VoidCallback onCopy;

  // endregion

  OptionMenuProduct({this.onShare, this.onDownload, this.onCopy});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      icon: Icon(
        Icons.sort,
        color: AppStyles.dartIcon,
      ),
      onSelected: (value) {
        _onClickItem(context, value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.home,
          child: _buildMenuItem(AppIcons.home, 'Trở về trang chủ', size: 20),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.category,
          child: _buildMenuItem(AppIcons.th_large_1, 'Danh mục sản phẩm',
              size: 20),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.user,
          child: _buildMenuItem(Icons.person, 'Cá nhân'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.favorite,
          child: _buildMenuItem(Icons.favorite, 'Yêu thích'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.share,
          child: _buildMenuItem(Icons.share, 'Đăng bài'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.download,
          child: _buildMenuItem(Icons.cloud_download, 'Tải hình về máy'),
        ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.copy,
          child: _buildMenuItem(Icons.content_copy, 'Copy thông tin SP'),
        ),
      ],
    );
  }

  _buildMenuItem(icon, name, {double size = 24}) {
    return Row(
      children: <Widget>[
        Container(
          width: 30,
          child: Icon(
            icon,
            color: AppStyles.dartIcon,
            size: size,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(name),
      ],
    );
  }

  _onClickItem(context, value) {
    switch (value) {
      case MenuOptions.home:
        Routes.navigateProduct(context, ANNPage.home);
        break;
      case MenuOptions.category:
        Routes.navigateProduct(context, ANNPage.category);
        break;
      case MenuOptions.user:
        Routes.navigateProduct(context, ANNPage.user);
        break;
      case MenuOptions.favorite:
        Routes.navigateProduct(context, ANNPage.favorite);
        break;
      case MenuOptions.share:
        if (onShare != null) onShare();
        break;
      case MenuOptions.download:
        if (onDownload != null) onDownload();
        break;
      case MenuOptions.copy:
        if (onCopy != null) onCopy();
        break;
    }
  }
}

enum MenuOptions {
  home,
  category,
  user,
  favorite,
  share,
  download,
  copy,
}
