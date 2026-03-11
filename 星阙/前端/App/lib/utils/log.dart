import 'package:logger/logger.dart';

// 单例
class Log {
  static Logger? _logger;

  static Logger getInstance() {
    _logger ??= Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
        ),
      );
    return _logger!;
  }

  static void t(dynamic message) {
    getInstance().t(message);
  }

  static void d(dynamic message) {
    getInstance().d(message);
  }

  static void i(dynamic message) {
    getInstance().i(message);
  }

  static void e(dynamic message) {
    getInstance().e(message);
  }

  static void w(dynamic message) {
    getInstance().w(message);
  }

  static void v(dynamic message) {
    getInstance().t(message);
  }

  static void wtf(dynamic message) {
    getInstance().f(message);
  }
}