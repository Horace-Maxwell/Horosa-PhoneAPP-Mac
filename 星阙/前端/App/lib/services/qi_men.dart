import 'package:dio/dio.dart';
import 'package:horosa/models/qi_men.dart';
import 'package:horosa/utils/http.dart';

class QiMenSvc {
  // 私有的 HTTPUtil 实例
  static final HTTPUtil _httpUtil = HTTPUtil();

  /// 获取六爻结果
  static Future<Response> getQiMenResult(QiMenInput data) async {
    final response = await _httpUtil.post(
      '/trigram/qimen',
      useCache: false,
      useAuth: false,
      data: data.toJson(),
    );
    return response;
  }
}
