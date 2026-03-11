import 'package:dio/dio.dart';
import 'package:horosa/models/liu_ren.dart';
import 'package:horosa/utils/http.dart';

class LiuRenSvc {
  // 私有的 HTTPUtil 实例
  static final HTTPUtil _httpUtil = HTTPUtil();

  /// 获取六爻结果
  static Future<Response> getLiuRenResult(LiuRenInput data) async {
    final response = await _httpUtil.post(
      '/trigram/liuren',
      useCache: false,
      useAuth: false,
      data: data.toJson(),
    );
    return response;
  }
}
