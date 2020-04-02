import 'package:shop_flutter/core/app_input_formatter.dart';
import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/model/account/account_register_state.dart';
import 'package:shop_flutter/repository/account_repository.dart';
import 'package:shop_flutter/repository/app_response.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:shop_flutter/ui/button/text_button.dart';
import 'package:shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterInputOtpView extends StatefulWidget {
  @override
  _RegisterInputOtpViewState createState() => _RegisterInputOtpViewState();
}

class _RegisterInputOtpViewState extends State<RegisterInputOtpView> {
  final _formKey = GlobalKey<FormState>();
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

    registerStream();
  }

  Stream<int> stream;
  int countDown;
  TextEditingController controllerOTP = TextEditingController();

  registerStream() {
    countDown = 60 - AccountRegisterState.instance.getDifferenceOTP();
    stream = Stream<int>.periodic(Duration(seconds: 1), transform);
    stream = stream.takeWhile((value) {
      return countDown > 0;
    });
    listenStream();
  }

  listenStream() async {
    await for (int i in stream) {
      setState(() {
        countDown = i;
      });
    }
  }

  int transform(int value) {
    int second = AccountRegisterState.instance.getDifferenceOTP();
    return 60 - second;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    stream.takeWhile((value) {
      return true;
    });
    super.dispose();
  }

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập mã OTP'),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text:
                                'Vui lòng nhập mã OTP đã gửi đến số điện thoại ',
                            style: Theme.of(context).textTheme.body1),
                        TextSpan(
                            text: AccountRegisterState.instance.phone,
                            style: Theme.of(context).textTheme.body2.merge(
                                TextStyle(
                                    decoration: TextDecoration.underline))),
                        TextSpan(
                            text: '  của quý khách',
                            style: Theme.of(context).textTheme.body1),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )),
              Container(
                alignment: Alignment.centerLeft,
                child: countDown <= 0
                    ? TextButton(
                        'Gửi lại OTP',
                        onPressed: () {
                          _onResentOTP();
                        },
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Gửi lại OTP (00:$countDown)',
                          style: Theme.of(context).textTheme.body2,
                        )),
              ),
              TextFormField(
                controller: controllerOTP,
                autofocus: true,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 15,
                    fontSize: 25,
                    color: Colors.black87),
                textAlign: TextAlign.center,
                showCursor: false,
                onFieldSubmitted: (String value) {
                  this._validateInput();
                },
                decoration: InputDecoration(
                  hintText: '______',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorStyle: Theme.of(context)
                      .textTheme
                      .caption
                      .merge(TextStyle(color: Colors.red)),
                ),
                inputFormatters: [OTPInputFormatter()],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value != AccountRegisterState.instance.otp) {
                    return 'OTP không trùng khớp';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(height: 30),
              RaisedButton(
                child: Text(
                  'Xác nhận',
                  style: TextStyle(color: ANNColor.white),
                ),
                onPressed: checkLength6() ? _validateInput : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkLength6() {
    String text = controllerOTP.text.replaceAll('_', '');
    return text.length == 6;
  }

  void _validateInput() {
    final form = _formKey.currentState;
    if (form.validate()) {
      _onValidateOTP();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future _onValidateOTP() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        final loadingDialog = new LoadingDialog(context, message: 'Xác nhận OTP...');

        loadingDialog.show();
        AppResponse response = await AccountRepository.instance
            .registerStep3ValidateOTP(AccountRegisterState.instance.phone,
                AccountRegisterState.instance.otp);
        loadingDialog.close();

        if (response.status) {
          Navigator.pushNamedAndRemoveUntil(context, 'user/register/password',
              ModalRoute.withName('user/login'));
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

  Future _onResentOTP() async {
    bool _checkInternet = await checkInternet();
    if (_checkInternet == false) {
      AppSnackBar.showFlushbar(context, 'Kiểm tra kết nối mạng và thử lại.');
    } else {
      try {
        final loadingDialog = new LoadingDialog(context);

        loadingDialog.show();
        AppResponse response = await AccountRepository.instance
            .registerStep2RequestOTP(AccountRegisterState.instance.phone,
                AccountRegisterState.instance.randomNewOtp());
        loadingDialog.close();

        if (response.status) {
          AccountRegisterState.instance.timeOTP = DateTime.now();
          registerStream();
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
