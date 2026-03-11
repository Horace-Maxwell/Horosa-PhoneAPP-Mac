import 'package:dio/dio.dart';
import 'package:horosa/utils/http.dart';

enum LogType {
  open(name: 'open', module: 'app'),
  bazi(name: 'bazi', module: 'trigram'),
  sixline(name: 'sixline', module: 'trigram'),
  liuren(name: 'liuren', module: 'trigram'),
  qimen(name: 'qimen', module: 'trigram');

  final String name;
  final String module;

  const LogType({ required this.name, required this.module });

  Map<String, dynamic> toJson() => {
    'operate': name,
    'module': module
  };
}

class LogSvc {
  static HTTPUtil httpUtil = HTTPUtil();

  static Future<Response> logging(LogType log) async {
    final response = await httpUtil.post(
      '/user/behavior',
      useCache: false,
      useAuth: false,
      data: log.toJson()
    );

    return response;
  }
}