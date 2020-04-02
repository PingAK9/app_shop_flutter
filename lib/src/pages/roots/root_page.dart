import 'dart:async';

import 'package:shop_flutter/core/app_dynamic_links.dart';
import 'package:shop_flutter/core/app_icons.dart';
import 'package:shop_flutter/core/app_onesignal.dart';
import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/provider/utility/search_provider.dart';
import 'package:shop_flutter/src/models/pages/root_pages/root_page_navigation_bar.dart';
import 'package:shop_flutter/src/pages/roots/notification_page.dart';
import 'package:shop_flutter/src/pages/roots/category_page.dart';
import 'package:shop_flutter/src/pages/roots/home_page.dart';
import 'package:shop_flutter/src/pages/roots/search_page.dart';
import 'package:shop_flutter/src/pages/roots/user_page.dart';
import 'package:shop_flutter/src/providers/roots/root_page_provider.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // region Parameters
  Timer _timer;

  List<Widget> pageList;

  // endregion

  @override
  void initState() {
    super.initState();

    AppDynamicLinks.instance.checkAndInit();
    WidgetsBinding.instance.addObserver(this);

    _timer = new Timer(const Duration(seconds: 5), () {
      try {
        Core.instance.versionCheck(context);
      } catch (e) {}
      AppOneSignal.instance.checkAndInit();
    });

    pageList = new List<Widget>();
    pageList.add(HomePage());
    pageList.add(CategoryPage());
    pageList.add(SearchPage());
    pageList.add(NotificationPage());
    pageList.add(UserPage());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RootPageProvider>(
        builder: (context, navigation, _) => new Scaffold(
            body: _buildBody(context, navigation.selectedPage),
            bottomNavigationBar:
                _buildBottomNavigationBar(context, navigation)));
  }

  // region build the page
  // Create body
  Widget _buildBody(BuildContext context, int selectedPage) {
    return IndexedStack(
      index: selectedPage,
      children: pageList,
    );
  }

  // Create bottom navigation bar
  Container _buildBottomNavigationBar(
      BuildContext context, RootPageProvider rootPageProvider) {
    final textStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    final bigScreen = MediaQuery.of(context).size.width >= 320;
    final btNavBarType = bigScreen
        ? BottomNavigationBarType.fixed
        : BottomNavigationBarType.shifting;

    return new Container(
      color: const Color(0xFF000000),
      child: BottomNavigationBar(
        showUnselectedLabels: bigScreen,
        backgroundColor: ANNColor.white,
        selectedLabelStyle: textStyle,
        unselectedLabelStyle: textStyle,
        type: btNavBarType,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(AppIcons.home_outline, size: 20),
            activeIcon: _buildIcon(AppIcons.home, size: 20),
            title: Text('Trang chủ'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(AppIcons.th_large_outline, size: 18),
            activeIcon: _buildIcon(AppIcons.th_large_1, size: 20),
            title: Text('Danh mục'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(AppIcons.search, size: 20),
            title: Text('Tìm kiếm'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.notifications_none),
            activeIcon: _buildIcon(Icons.notifications),
            title: Text('Thông báo'),
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.perm_identity),
            activeIcon: _buildIcon(Icons.person),
            title: Text('Cá nhân'),
          ),
        ],
        currentIndex: rootPageProvider.selectedPage,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: ANNColor.black,
        onTap: (int index) => _navigate(context, rootPageProvider, index),
      ),
    );
  }

  // Create Icon
  Widget _buildIcon(IconData icon, {double size}) {
    return Container(
        height: 30,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: size,
        ));
  }

// endregion

  void _navigate(BuildContext context, RootPageProvider rootPageProvider,
      int selectedPage) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    if (selectedPage == RootPageNavigationBar.search) {
      searchProvider.setOpenKeyBoard(true);
    } else {
      searchProvider.setOpenKeyBoard(false);
    }

    rootPageProvider.navigate(selectedPage);
  }
}
