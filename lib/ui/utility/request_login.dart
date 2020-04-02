import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';

class RequestLogin extends StatelessWidget {
  RequestLogin(
      {this.message =
          'Vui lòng đăng nhập hoặc đăng ký để sử dụng chức năng này'});

  final message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                message,
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Đăng nhập',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .merge(TextStyle(color: ANNColor.white)),
                  ),
                  onPressed: () {
                    _onLogIn(context);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Bạn chưa có tài khoản ',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  InkWell(
                    onTap: () {
                      _onLogIn(context);
                    },
                    child: Text(
                      'Đăng ký ngay.',
                      style: Theme.of(context).textTheme.button.merge(
                            TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _onLogIn(context) {
    Navigator.pushNamedAndRemoveUntil(
        context, 'user/login', (Route<dynamic> route) => false);
  }
}
