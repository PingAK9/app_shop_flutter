import 'dart:developer' as developer;

import 'package:shop_flutter/core/core.dart';

class ANNLogging {
  // region Singleton Pattern
  static final _instance = ANNLogging._internal();

  // endregion

  // region Getter
  static ANNLogging get instance => _instance;

  // endregion

  ANNLogging._internal();

  factory ANNLogging() => _instance;

  void logInfo(String message) {
    developer.log(message, time: DateTime.now(), name: Core.appSchema);
  }

  void logError(String message, Object e) {
    developer.log(message,
        time: DateTime.now(), name: Core.appSchema, error: e);
  }
}
