import 'package:shop_flutter/core/app_input_formatter.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/account/account.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/copy_setting/copy_controller.dart';
import 'package:shop_flutter/model/copy_setting/copy_setting.dart';
import 'package:shop_flutter/ui/utility/request_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  Account _account;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._account = Account.fromJson(AccountController.instance.account.toJson());
    CopySetting copy = CopyController.instance.copySetting;

    if (copy.showed == false && this._account != null) {
      if (this._account.phone?.isEmpty == false) {
        copy.phoneNumber = this._account.phone;
      }
      if (this._account.address?.isEmpty == false) {
        copy.address = this._account.address;
      }
    }
    controllerBonus =
        TextEditingController(text: Utility.formatPrice(copy.bonusPrice));
    controllerPhone = TextEditingController(text: copy.phoneNumber.toString());
    controllerAddress = TextEditingController(text: copy.address.toString());
    setState(() {
      valueCode = copy.productCode;
      valueName = copy.productName;
    });
  }

  TextEditingController controllerBonus = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  bool valueCode = false;
  bool valueName = false;

  _saveSetting() {
    String _value = controllerBonus.text ?? '';
    _value = _value.replaceAll(',', '');
    int _bonus = _value.isEmpty ? 0 : int.parse(_value);
    CopySetting copy = CopySetting(
      productName: valueName,
      productCode: valueCode,
      address: controllerAddress.text,
      phoneNumber: controllerPhone.text,
      bonusPrice: _bonus,
      showed: true,
    );
    CopyController.instance.updateCopySetting(copy);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveSetting();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cài đặt copy sản phẩm'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _saveSetting();
              Navigator.pop(context);
            },
          ),
        ),
        body: AccountController.instance.isLogin == false
            ? RequestLogin()
            : Container(
                child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SizedBox(
                              height: 15,
                            ),
                            _buildItemCommon('Hiện mã sản phẩm',
                                trailing: CupertinoSwitch(
                                  value: valueCode,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      valueCode = value;
                                    });
                                  },
                                )),
                            _buildItemCommon('Hiện tên sản phẩm',
                                trailing: CupertinoSwitch(
                                  value: valueName,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      valueName = value;
                                    });
                                  },
                                )),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                              child: TextField(
                                controller: controllerBonus,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Giá lẽ cộng thêm',
                                ),
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  CurrencyInputFormatter()
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: TextField(
                                controller: controllerPhone,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  labelText: 'Điện thoại của khách',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: TextField(
                                controller: controllerAddress,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Địa chỉ của khách'),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: 'Hướng dẫn:',
                                      style: new TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' sau khi copy nội dung, quý khách hãy dán vào nơi đăng bài Facebook/Zalo để đăng bán online.',
                                      style: new TextStyle(fontSize: 16))
                                ])))
                          ],
                        ),
                      )
                    ]),
              ),
      ),
    );
  }

  Widget _buildItemCommon(String title, {trailing}) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: ListTile(
        onTap: null,
        title: Text(title),
        trailing: trailing,
      ),
    );
  }
}
