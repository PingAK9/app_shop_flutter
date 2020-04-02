import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:flutter/material.dart';

class AskLogin extends StatelessWidget {
  static show(context,
      {message = 'Vui lòng đăng nhập hoặc đăng ký để sử dụng chức năng này'}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return AskLogin(message);
      },
    );
  }

  AskLogin(this.message);

  final message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ANNColor.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 30,
                ),
                Text(
                  'Đăng Nhập / Đăng Ký',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.title,
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
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
    );
  }

  _onLogIn(context) {
    Navigator.pushNamedAndRemoveUntil(
        context, 'user/login', (Route<dynamic> route) => false);
  }
}
