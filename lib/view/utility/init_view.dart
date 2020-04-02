import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/copy_setting/copy_controller.dart';
import 'package:shop_flutter/provider/utility/cover_provider.dart';
import 'package:shop_flutter/src/controllers/common/user_controller.dart';
import 'package:shop_flutter/ui/utility/indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitView extends StatefulWidget {
  @override
  _InitViewState createState() => _InitViewState();
}

class _InitViewState extends State<InitView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: Container(
              height: 70,
              width: 200,
              child: Image.asset(
                'assets/images/ui/ann.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Indicator(),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAccountInfo();
    CopyController.instance.loadCopySetting();
  }

  checkAccountInfo() async {
    await AccountController.instance.loadFormLocale();
    await UserController.instance.refreshToken(context);
    CoverProvider provider = Provider.of(context, listen: false);
    await provider.loadPostHome();
    if (provider.postsHome.isCompleted) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.pushReplacementNamed(context, 'user/login');
    }
  }
}
