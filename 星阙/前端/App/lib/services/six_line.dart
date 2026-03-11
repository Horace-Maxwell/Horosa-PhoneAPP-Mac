import 'package:dio/dio.dart';
import 'package:horosa/models/liu_lines.dart';
import 'package:horosa/utils/http.dart';

class SixLineSvc {
  // 私有的 HTTPUtil 实例
  static final HTTPUtil _httpUtil = HTTPUtil();

  /// 获取六爻结果
  static Future<Response> getSixLinesResult(LiuYaoInput data) async {
    final response = await _httpUtil.post(
      '/trigram/sixline',
      useCache: false,
      useAuth: false,
      data: data.toJson(),
    );
    return response;
  }
}
