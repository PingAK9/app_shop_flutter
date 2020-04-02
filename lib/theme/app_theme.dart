import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';

final TextStyle _title = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    letterSpacing: 0.15,
    color: Colors.black87);

final ThemeData primaryTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  primaryColor: Colors.orange,
  buttonColor: Colors.orange,

  /// App bar theme
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
//        color: Colors.white,
    actionsIconTheme: IconThemeData(
      color: ANNColor.white,
    ),
    iconTheme: IconThemeData(
      color: ANNColor.white,
    ),
    textTheme: TextTheme(
      title: _title.merge(
        TextStyle(
          color: ANNColor.white,
        ),
      ),
    ),
  ),
  textTheme: TextTheme(
      title: _title,
      display1: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      display2: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87)),
  iconTheme: IconThemeData(
    color: Colors.grey[800],
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(12),
    border: const OutlineInputBorder(),
    hintStyle:
        TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.normal),
  ),
  buttonTheme: const ButtonThemeData(height: 40),

  /// Support swipe from edge to navigate the previous scene
  /// for both iOS and android
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);
