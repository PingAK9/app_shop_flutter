import 'package:shop_flutter/core/app_analytics.dart';
import 'package:shop_flutter/provider/category/category_provider.dart';
import 'package:shop_flutter/provider/favorite/favorite_provider.dart';
import 'package:shop_flutter/provider/product/category_product_provider.dart';
import 'package:shop_flutter/provider/product/product_provider.dart';
import 'package:shop_flutter/provider/product/seen_provider.dart';
import 'package:shop_flutter/provider/utility/blog_provider.dart';
import 'package:shop_flutter/provider/utility/config_provider.dart';
import 'package:shop_flutter/provider/utility/coupon_provider.dart';
import 'package:shop_flutter/provider/utility/cover_provider.dart';
import 'package:shop_flutter/provider/utility/download_image_provider.dart';
import 'package:shop_flutter/provider/utility/inapp_provider.dart';
import 'package:shop_flutter/provider/utility/search_provider.dart';
import 'package:shop_flutter/provider/utility/spam_cover_provider.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/src/providers/roots/root_page_provider.dart';
import 'package:shop_flutter/theme/app_theme.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
      .copyWith(statusBarIconBrightness: Brightness.light));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static BuildContext get context => navKey.currentState.overlay.context;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RootPageProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProductProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
        ChangeNotifierProvider(create: (_) => SeenProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CoverProvider()),
        ChangeNotifierProvider(create: (_) => InAppProvider()),
        ChangeNotifierProvider(create: (_) => DownloadImageProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => CoverProvider()),
        ChangeNotifierProvider(create: (_) => SpamCoverProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: MyApp.navKey,
        title: 'ANN App',
        theme: primaryTheme,
        initialRoute: '/',
        onGenerateRoute: Routes.generateRoute,
        navigatorObservers: [observer],
        locale: Locale('vi'),
      ),
    );
  }

  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
      analytics: AppAnalytics.instance.firebase,
      nameExtractor: Routes.getNameExtractor);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
