import 'package:flutter/material.dart';

class ANNColor {
  // region App Bar
  static const appBarColor = orange;
  static const searchColor = white;
  static const iconSearchColor = grey;
  static const favoriteColor = white;

  // endregion

  // region Body
  static const dividerColor = Color(0x1f000000);
  static const blockColor = white;
  static const titleBlockColor = white;
  static const cardColor = white;
  static const viewMoreColor = white;

  // endregion

  // region Bottom
  static const bottomNavigationBarColor = Color(0xff616161);

  // endregion

  // region Name Color
  static const white = Color(0xffffffff);
  static const orange = Color(0xffff9800);
  static const grey = Color(0xff9e9e9e);
  static const black = Colors.black87;
// endregion
}

class DarkColor {
  // example dark mode
  final primaryColor = Colors.purple[200];
  final primaryVariantColor = Colors.blue[700];
  final secondaryColor = Colors.teal[200];
  final secondaryVariantColor = Colors.teal[200];
  final backgroundColor = Color(0xff121212);
  final surfaceColor = Color(0xff1e1e1e);
  final errorColor = Color(0xffcf6679);

  final onPrimaryColor = Colors.black;
  final onSecondaryColor = Colors.black;
  final onBackgroundColor = ANNColor.white;
  final onSurfaceColor = ANNColor.white;
  final onErrorColor = Colors.black;
}
