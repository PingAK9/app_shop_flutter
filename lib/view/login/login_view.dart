import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/validator.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/account/account_register_state.dart';
import 'package:shop_flutter/repository/account_repository.dart';
import 'package:shop_flutter/repository/app_response.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:shop_flutter/ui/utility/ann-logo.dart';
import 'package:shop_flutter/ui/utility/app_popup.dart';
import 'package:shop_flutter/ui/utility/app_snackbar.dart';
import 'package:shop_flutter/ui/utility/bottom_bar_policy.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // region Parameters
  final _formKey = GlobalKey<FormState>();

  AccountController _accountController;
  bool _autoValidate;

  String phone;

  // endregion

  // region Widget
  ScrollController _scrollController;

  // endregion

  @override
  void initState() {
    super.initState();

    _accountController = AccountController.instance;
    _autoValidate = false;

    if (_accountController.account != null &&
        !isEmpty(_accountController.account.phone)) {
      phone = _accountController.account.phone;
    }

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset < -50) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Core.appFullName),
      ),
      bottomNavigationBar: BottomBarPolicy(),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Container(
                height: 100,
                margin: const EdgeInsets.only(top: 50, bottom: 40),
                child: AnnLogo(),
              ),
              TextFormField(
                  initialValue: phone,
                  autofocus: true,
                  maxLength: 10,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_iphone),
                    hintText: 'Nhập số điện thoại',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: Validator.phoneNumberValidator,
                  onSaved: (value) {
                    phone = value;
                  },
                  onFieldSubmitted: (String value) {
                    _validateInput();
                  }),
              const SizedBox(height: 15),
              RaisedButton(
                onPressed: _validateInput,
                child: Text(
                  'Tiếp tục',
                  style: TextStyle(color: ANNColor.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateInput() {
    FocusScope.of(context).requestFocus(FocusNode());
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      onLogin();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future onLogin() async {
    final bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        final loadingDialog =
            new LoadingDialog(context, message: 'Kiểm tra số điện thoại...');

        loadingDialog.show();
        final AppResponse response =
            await AccountRepository.instance.checkPhoneNumber(phone);
        loadingDialog.close();

        if (response.status) {
          if (response.data) {
            AccountRegisterState.instance.isRegister = false;
            await Navigator.pushNamed(context, 'user/login/password',
                arguments: phone);
          } else {
            await AppPopup.showCustomDialog(context, content: [
              AvatarGlow(
                endRadius: 50,
                duration: const Duration(milliseconds: 1000),
                glowColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.warning,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Số điện thoại ',
                        style: Theme.of(context).textTheme.body1),
                    TextSpan(
                        text: phone,
                        style: Theme.of(context).textTheme.body2.merge(
                            TextStyle(decoration: TextDecoration.underline))),
                    TextSpan(
                        text: ' chưa được đăng ký. Bạn có muốn đăng ký?',
                        style: Theme.of(context).textTheme.body1),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              CenterButtonPopup(
                normal: ButtonData('Quay lại'),
                highlight: ButtonData('Đăng ký', onPressed: onSentOTP),
              )
            ]);
          }
        } else {
          AppSnackBar.showFlushbar(context,
              response.message ?? 'Có lỗi xãi ra, vui lòng thử lại sau.');
        }
      } catch (e) {
        print(e);
        AppSnackBar.showFlushbar(
            context, 'Có lỗi xãi ra, vui lòng thử lại sau.');
      }
    }
  }

  Future onSentOTP() async {
    try {
      AccountRegisterState.instance.phone = phone;
      AccountRegisterState.instance.isRegister = true;
      if (AccountRegisterState.instance.checkTimeOTP() == false) {
        await Navigator.pushNamed(context, 'user/otp');
        return;
      }

      final loadingDialog = new LoadingDialog(context, message: 'Gửi OTP...');

      loadingDialog.show();
      final AppResponse response = await AccountRepository.instance
          .registerStep2RequestOTP(
              phone, AccountRegisterState.instance.randomNewOtp());
      loadingDialog.close();

      if (response.status) {
        AccountRegisterState.instance.timeOTP = DateTime.now();
        await Navigator.pushNamed(context, 'user/otp');
      } else {
        AppSnackBar.showFlushbar(context,
            response.message ?? 'Có lỗi xãi ra, vui lòng thử lại sau.');
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Có lỗi xãi ra, vui lòng thử lại sau.');
    }
  }
}
