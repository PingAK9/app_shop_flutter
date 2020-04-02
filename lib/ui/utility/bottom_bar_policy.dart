import 'package:shop_flutter/ui/button/text_button.dart';
import 'package:flutter/material.dart';

class BottomBarPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: TextButton(
          'Chính sách và điều khoản của ANN',
          onPressed: () {
            Navigator.pushNamed(context, 'shop/policy');
          },
        ),
      ),
    );
  }
}
