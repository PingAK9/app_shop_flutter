import 'package:intl/intl.dart';

class Utility {
  static bool isNullOrEmpty(object) {
    if (object == null) {
      return true;
    }
    if (object is String) {
      return object.trim().isEmpty;
    }
    if (object is Iterable) {
      return object.isEmpty;
    }
    if (object is Map) {
      return object.keys.isEmpty;
    }
    return false;
  }

  static String formatPrice(dynamic number) {
    final oCcy = new NumberFormat("#,###", "en_US");
    if (number is String) {
      if (number.toString().isNotEmpty) {
        int value = int.parse(number);

        return oCcy.format(value);
      } else {
        return '';
      }
    } else {
      return oCcy.format(number);
    }
  }

  static String fixFormatDate(String oldDay) {
    try {
      DateTime dateTime = DateTime.parse(oldDay);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      print(e);
      return '';
    }
  }
}
