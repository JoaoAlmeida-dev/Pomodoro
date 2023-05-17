import 'dart:developer';

class Logger {
  static void debug({required Object message, StackTrace? stackTrace}) {
    log(message.toString(), error: stackTrace);
  }

  static void info({required Object message, StackTrace? stackTrace}) {
    log(message.toString(), error: stackTrace);
  }

  static void trace({required Object message, StackTrace? stackTrace}) {
    log(message.toString(), error: stackTrace);
  }

  static void error({required Object message, StackTrace? stackTrace}) {
    log(message.toString(), error: stackTrace);
  }
}
