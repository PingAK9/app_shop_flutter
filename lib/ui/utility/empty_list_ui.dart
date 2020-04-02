import 'package:shop_flutter/core/utility.dart';
import 'package:flutter/material.dart';

class EmptyListUI extends StatelessWidget {
  const EmptyListUI({this.image, this.title, this.body});

  final String title;
  final String body;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: image ??
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('assets/images/ui/recycle_bin_empty.png'),
                ),
          ),
          if (Utility.isNullOrEmpty(title) == false)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                title,
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.center,
              ),
            ),
          if (Utility.isNullOrEmpty(body) == false)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                body,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
