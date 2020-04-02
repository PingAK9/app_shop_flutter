class Validator {
  static String phoneNumberValidator(String value) {
    if (value == null || value.length == 0) {
      return 'Vui lòng nhập số điện thoại';
    } else if (value.length  != 10) {
      return 'Số điện thoại chưa đúng';
    }
    return null;
  }

  static String passwordValidator(String value) {
    if (value == null || value.length == 0) {
      return 'Vui lòng nhập mật khẩu';
    } else if (value.length < 6) {
      return 'Mật khẩu tối thiểu 6 ký tự';
    }
    return null;
  }
}
