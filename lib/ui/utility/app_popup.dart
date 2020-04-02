import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';

class AppPopup {
  static Future<void> showCustomDialog(BuildContext context,
      {String title,
      Widget titleWidget,
      List<Widget> content,
      List<Widget> actions,
      bool barrierDismissible = true}) async {
    Widget _titleWidget;
    if (titleWidget == null && title != null) {
      _titleWidget = Text(
        title,
        textAlign: TextAlign.center,
      );
    } else {
      _titleWidget = titleWidget;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return AlertDialog(
          title: _titleWidget,
          content: (content != null)
              ? SingleChildScrollView(
                  child: ListBody(
                    children: content,
                  ),
                )
              : null,
          actions: actions,
        );
      },
    );
  }

  static Future<void> showBottomSheet(BuildContext context,
      {String title, List<Widget> content}) async {
    Widget titleWidget;
    if (Utility.isNullOrEmpty(title) == false) {
      titleWidget = Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: ANNColor.white,
          border: Border(
              bottom: BorderSide(
            color: ANNColor.dividerColor,
            width: 1,
            style: BorderStyle.solid,
          )),
        ),
        height: kToolbarHeight,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
                maxLines: 3,
                softWrap: true,
              ),
            ),
            Container(
              width: 40,
            ),
          ],
        ),
      );
    }
    final _scrollWidget = Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        child: ListBody(
          children: [
            SizedBox(height: titleWidget != null ? 60 : 15),
            ...content,
            Container(height: 20)
          ],
        ),
      ),
    );

    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          child: titleWidget == null
              ? _scrollWidget
              : Stack(
                  children: <Widget>[
                    _scrollWidget,
                    Positioned(
                      top: 0,
                      child: titleWidget,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

enum MenuItem { edit, delete, open, setDefault }

class ButtonData {
  ButtonData(this.text, {this.onPressed});

  final String text;
  final VoidCallback onPressed;
}

class CenterButtonPopup extends StatelessWidget {
  const CenterButtonPopup({this.normal, this.highlight});

  final ButtonData normal;
  final ButtonData highlight;

  @override
  Widget build(BuildContext context) {
    Widget btnNormal;
    if (normal != null) {
      btnNormal = ButtonTheme(
        height: 35,
        child: RaisedButton(
          color: Colors.grey[200],
          onPressed: () {
            Navigator.pop(context);
            if (normal.onPressed != null) {
              normal.onPressed();
            }
          },
          child: Text(
            normal.text,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      );
    }
    Widget btnHighlight;
    if (highlight != null) {
      btnHighlight = ButtonTheme(
        height: 35,
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
            if (highlight.onPressed != null) {
              highlight.onPressed();
            }
          },
          child: Text(
            highlight.text,
            style: TextStyle(color: ANNColor.white),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: (btnNormal != null && btnHighlight != null)
          ? Row(
              children: <Widget>[
                Expanded(
                  child: btnNormal,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: btnHighlight,
                ),
              ],
            )
          : Center(
              child: btnNormal ?? btnHighlight,
            ),
    );
  }
}
