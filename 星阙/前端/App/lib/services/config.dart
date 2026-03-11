import 'package:dio/dio.dart';
import 'package:horosa/utils/http.dart';

class ConfigSvc {
  static HTTPUtil httpUtil = HTTPUtil();

  /// 获取金刚区列表
  static Future<Response> getDocks() async {
    final response = await httpUtil.post(
      baseUrl: 'https://api.horosa.com',
      '/trigram/quick_link',
      useCache: false,
      useAuth: false,
    );

    return response;
  }
}
