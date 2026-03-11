import 'package:dio/dio.dart';
import 'package:horosa/utils/http.dart';
import 'package:horosa/utils/log.dart';

class WechatSvc {
  // 私有的 HTTPUtil 实例
  static final HTTPUtil _httpUtil = HTTPUtil();

  // 通过 code 换取 access_token
  static Future<Response> getAccessToken(String code) async {
    Log.d('Request code: $code');
    final response = await _httpUtil.post(
      '/user/login/wechat',
      useCache: false,
      useAuth: false,
      data: {
        'code': code,
      },
    );
    return response;
  }

  // 刷新 access_token
  static Future<Response> refreshToken({
    required String appId,
    required String refreshToken,
  }) async {
    final response = await _httpUtil.get(
      '/sns/oauth2/refresh_token',
      queryParameters: {
        'appid': appId,
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );
    return response;
  }

  // 获取用户基本信息
  static Future<Response> getUserInfo({
    required String accessToken,
    required String openId,
  }) async {
    final response = await _httpUtil.get(
      '/sns/userinfo',
      queryParameters: {
        'access_token': accessToken,
        'openid': openId,
        'lang': 'zh_CN',
      },
    );
    return response;
  }

  // 验证 token 是否有效
  static Future<Response> auth({
    required String accessToken,
    required String openId,
  }) async {
    final response = await _httpUtil.get(
      '/sns/auth',
      queryParameters: {
        'access_token': accessToken,
        'openid': openId,
      },
    );
    return response;
  }
}
