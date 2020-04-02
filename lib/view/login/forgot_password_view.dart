import 'package:shop_flutter/core/core.dart';
import 'package:shop_flutter/core/utility.dart';
import 'package:shop_flutter/model/account/account_register_state.dart';
import 'package:shop_flutter/repository/account_repository.dart';
import 'package:shop_flutter/repository/app_response.dart';
import 'package:shop_flutter/src/themes/ann_color.dart';
import 'package:shop_flutter/src/widgets/loading/loading_dialog.dart';
import 'package:shop_flutter/ui/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class ForgotPasswordView extends StatefulWidget {
  ForgotPasswordView(this.phone);

  final phone;

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _controllerBirthDate;

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

    _controllerBirthDate =
        TextEditingController(text: Utility.fixFormatDate(''));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;
  String password;
  String birthDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: ListView(
            controller: _scrollController,
            children: [
              SizedBox(height: 50),
              TextFormField(
                style: TextStyle(fontWeight: FontWeight.w600),
                initialValue: widget.phone,
                enabled: false,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_iphone),
                ),
              ),
              SizedBox(height: 15),
              InkWell(
                onTap: Utility.isNullOrEmpty(password)
                    ? _showDateTimePicker
                    : null,
                child: IgnorePointer(
                  child: TextFormField(
                    style: TextStyle(fontWeight: FontWeight.w600),
                    controller: _controllerBirthDate,
                    readOnly: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.date_range),
                      helperText: ' ',
                      hintText: 'Chọn ngày sinh',
                    ),
                    validator: (value) {
                      if (Utility.isNullOrEmpty(value)) {
                        return 'Chưa chọn ngày sinh';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              RaisedButton(
                child: Text(
                  'Tiếp tục',
                  style: TextStyle(color: ANNColor.white),
                ),
                onPressed: _validateInput,
              ),
              SizedBox(height: 15),
              RaisedButton(
                color: ANNColor.white,
                child: Text('Quên ngày sinh'),
                onPressed: () {
                  onSentOTP();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  final _formatDatePicker = 'd  M  yyyy';

  _showDateTimePicker() {
    DateTime now = DateTime.now();
    DateTime temp = new DateTime(now.year - 25, 1, 1);
    if (Utility.isNullOrEmpty(birthDay) == false) {
      temp = DateTime.parse(birthDay);
    }
    DateTime maxDay = new DateTime.utc(DateTime.now().year - 1, 12, 31);

    DatePicker.showDatePicker(
      context,
      initialDateTime: temp,
      dateFormat: _formatDatePicker,
      maxDateTime: maxDay,
      pickerMode: DateTimePickerMode.date,
      onCancel: () {
        updateDate(null);
      },
      onChange: (dateTime, List<int> index) {
        updateDate(dateTime);
      },
      onConfirm: (dateTime, List<int> index) {
        updateDate(dateTime);
        this._validateInput();
      },
    );
  }

  void updateDate(DateTime dateTime) {
    if (dateTime != null) {
      setState(() {
        birthDay = DateFormat('yyyy-MM-dd').format(dateTime);
        _controllerBirthDate.text = Utility.fixFormatDate(birthDay);
      });
    }
  }

  void _validateInput() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _onForgotPassword();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future _onForgotPassword() async {
    try {
      final loadingDialog = new LoadingDialog(context);

      loadingDialog.show();
      AppResponse response = await AccountRepository.instance
          .forgotPasswordByBirthDay(widget.phone, birthDay);
      loadingDialog.close();

      if (response.status) {
        /// go to update password
        AccountRegisterState.instance.otp = response.data;
        AccountRegisterState.instance.phone = widget.phone;
        Navigator.pushNamedAndRemoveUntil(context, 'user/register/password',
            ModalRoute.withName('user/login'));
      } else {
        AppSnackBar.showFlushbar(context, 'Ngày sinh không đúng.');
      }
    } catch (e) {
      print(e);
      AppSnackBar.showFlushbar(context, 'Ngày sinh không đúng.');
    }
  }

  onSentOTP() async {
    try {
      AccountRegisterState.instance.phone = widget.phone;
      if (AccountRegisterState.instance.checkTimeOTP() == false) {
        Navigator.pushNamed(context, 'user/otp');
        return;
      }

      final loadingDialog = new LoadingDialog(context, message: 'Gửi OTP...');

      loadingDialog.show();
      AppResponse response = await AccountRepository.instance
          .registerStep2RequestOTP(
              widget.phone, AccountRegisterState.instance.randomNewOtp());
      loadingDialog.close();

      if (response.status) {
        AccountRegisterState.instance.timeOTP = DateTime.now();
        Navigator.pushNamed(context, 'user/otp');
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
