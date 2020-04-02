import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/validator.dart';
import 'package:shop_flutter/model/account/account_controller.dart';
import 'package:shop_flutter/model/account/account_register_state.dart';
import 'package:shop_flutter/repository/account_repository.dart';
import 'package:shop_flutter/repository/app_response.dart';
import 'package:shop_flutter/src/configs/route.dart';
import 'package:shop_flutter/src/models/ann_page.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterInputPasswordView extends StatefulWidget {
  @override
  _RegisterInputPasswordViewState createState() =>
      _RegisterInputPasswordViewState();
}

class _RegisterInputPasswordViewState extends State<RegisterInputPasswordView> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _passwordFocus;
  FocusNode _confirmPasswordFocus;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset < -50) {
        if (MediaQuery.of(context).viewInsets.bottom > 100 || true) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      }
    });
    showPassword = false;

    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;
  String confirmPassword;
  String password;
  bool showPassword;

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tạo mật khẩu'),
          leading: Container(),
        ),
        body: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                SizedBox(height: 50),
                TextFormField(
                  focusNode: _passwordFocus,
                  obscureText: !showPassword,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  onFieldSubmitted: (String value) {
                    this._fieldFocusChange(
                        context, _passwordFocus, _confirmPasswordFocus);
                  },
                  decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      )),
                  textInputAction: TextInputAction.next,
                  validator: Validator.passwordValidator,
                  onSaved: (String value) {
                    password = value;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  focusNode: _confirmPasswordFocus,
                  obscureText: !showPassword,
                  style: TextStyle(fontWeight: FontWeight.w600),
                  onFieldSubmitted: (String value) {
                    _confirmPasswordFocus.unfocus();
                    this._validateInput();
                  },
                  decoration: InputDecoration(
                      helperText: ' ',
                      hintText: 'Nhập lại mật khẩu',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      )),
                  textInputAction: TextInputAction.done,
                  validator: Validator.passwordValidator,
                  onSaved: (String value) {
                    confirmPassword = value;
                  },
                ),
                SizedBox(height: 15),
                RaisedButton(
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(color: ANNColor.white),
                  ),
                  onPressed: _validateInput,
                ),
              ],
            ),
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
      if (password != confirmPassword) {
        AppSnackBar.showFlushbar(context, 'Nhập lại mật khẩu chưa đúng');
      } else {
        onSubmit();
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future onSubmit() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        final loadingDialog = new LoadingDialog(context);

        loadingDialog.show();
        AppResponse response = await AccountRepository.instance
            .registerStep4CreatePassword(AccountRegisterState.instance.phone,
                AccountRegisterState.instance.otp, password);
        loadingDialog.close();

        if (response.status) {
          AccountController.instance.finishLogin(response.data, password);
          if (AccountRegisterState.instance.isRegister) {
            Navigator.pushNamedAndRemoveUntil(context,
                'user/register/information', (Route<dynamic> route) => false);
          } else {
            Routes.navigateForgetPassword(context, ANNPage.home);
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
}
