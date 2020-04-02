import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final value = int.parse(newValue.text);

    final formatter = NumberFormat("###,###", "en_US");

    final newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}

class OTPInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var newText = newValue.text;
    if (newText.length == 5) {
      if (oldValue.text.contains('_')) {
        newText = newText.replaceAll(RegExp('[^0-9]'), '');
        if (newText.isNotEmpty) {
          newText = newText.substring(0, newText.length - 1);
        }
      } else {}
    } else {
      newText = newText.replaceAll(RegExp('[^0-9]'), '');
    }
    for (var i = newText.length; i < 6; i++) {
      newText += '_';
    }
    newText = newText.substring(0, 6);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
