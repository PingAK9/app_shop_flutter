import 'dart:async';

import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/src/controllers/common/user_controller.dart';
import 'package:shop_flutter/src/controllers/views/view_controller.dart';
import 'package:shop_flutter/src/models/views/view_model.dart';
import 'package:shop_flutter/src/models/views/view_navigation_bar.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:shop_flutter/ui/utility/html_content.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:shop_flutter/ui/utility/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';

class ViewMorePage extends StatefulWidget {
  // region Parameters
  final slug;

  // endregion

  ViewMorePage(this.slug);

  @override
  _ViewMorePageState createState() => _ViewMorePageState();
}

class _ViewMorePageState extends State<ViewMorePage> {
  // region Parameters
  ViewController _controller;
  Future<ViewModel> _fetchData;

  int _selectedIndex;

  // endregion

  @override
  void initState() {
    super.initState();

    _controller = ViewController.instance;
    _fetchData = _controller.getViewBySlug(widget.slug);

    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ViewModel>(
      future: _fetchData,
      builder: (BuildContext context, AsyncSnapshot<ViewModel> snapshot) {
        if (snapshot.hasData) {
          return _buildSuccess(context, snapshot.data);
        } else if (snapshot.hasError) {
          return _buildError(context);
        }

        // By default, show a loading spinner.
        return _buildLoading(context);
      },
    );
  }

  // region build
  // build the page when it is loading
  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đang tải...'),
      ),
      body: Container(child: Indicator()),
    );
  }

  //build the page when it is loaded
  Widget _buildSuccess(BuildContext context, ViewModel data) {
    String title = isEmpty(data.title) ? 'Thông báo' : data.title;
    String content = data.content;
    Widget child;

    if (Utility.isNullOrEmpty(content))
      child = new Center(
        child: Text('Không có nội dung'),
      );
    else
      child = new ListView(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          HtmlContent(content),
        ],
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: child,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, data),
    );
  }

  // build the page when it has exception
  Widget _buildError(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đang tải...'),
      ),
      body: Container(child: SomethingWentWrong(
        onReload: () async {
          await UserController.instance.refreshToken(context);
          setState(() {
            _fetchData = _controller.getViewBySlug(widget.slug);
          });
        },
      )),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, ViewModel data) {
    return new BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.cloud_download),
          title: Text(
            'Tải hình',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.share),
          title: Text(
            'Đăng bài',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.content_copy),
          title: Text(
            'Copy',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        )
      ],
      onTap: (int index) => _onItemTapped(context, index, data),
      currentIndex: _selectedIndex,
      elevation: 1.0,
      selectedItemColor: ANNColor.black,
      unselectedItemColor: ANNColor.black,
      selectedFontSize: 12,
      unselectedFontSize: 12
    );
  }

  // endregion

  void _onItemTapped(BuildContext context, int index, ViewModel data) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case ViewNavigationBar.download:
        _onClickDownload(context, data.images);
        break;
      case ViewNavigationBar.share:
        _onClickShare(context, data);
        break;
      case ViewNavigationBar.copy:
        _onClickCopy(context, data.postContent);
        break;
      default:
        break;
    }
  }

  void _onClickDownload(BuildContext context, List<String> images) async {
    if (images == null || images.length == 0) return;

    _controller.downloadImage(context, images);
  }

  void _onClickShare(BuildContext context, ViewModel data) async {
    final loadingDialog = LoadingDialog(context, message: 'Đang xử lý...');

    loadingDialog.show();
    Navigator.pushNamed(context, 'product/detail/share-social', arguments: {
      'images': data.images,
      'title': data.title,
      'message': data.postContent
    }).then((_) => loadingDialog.close());
  }

  void _onClickCopy(BuildContext context, String content) async {
    if (isEmpty(content)) return;

    final loadingDialog = LoadingDialog(context, message: 'Đang copy...');

    loadingDialog.show();
    await Future.delayed(const Duration(milliseconds: 500));
    await Clipboard.setData(new ClipboardData(text: content));
    loadingDialog.message = 'Đã copy xong';
    await Future.delayed(const Duration(milliseconds: 500));
    loadingDialog.close();
  }
}
