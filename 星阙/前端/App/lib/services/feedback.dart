import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:horosa/constants/keys.dart';
import 'package:horosa/utils/http.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/utils/local_storage.dart';

class FeedbackSvc {
  static HTTPUtil httpUtil = HTTPUtil();
  static LocalStorage localStorage = LocalStorage();

  /// 意见反馈
  static Future<Response> feedback(String content) async {
    if (LocalMode.enabled) {
      final raw = await localStorage.read(AppKeys.localFeedbacks);
      final list = raw == null || raw.isEmpty
          ? <Map<String, dynamic>>[]
          : (jsonDecode(raw) as List)
              .map((e) => (e as Map<dynamic, dynamic>).cast<String, dynamic>())
              .toList();
      list.add({
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
      });
      await localStorage.write(AppKeys.localFeedbacks, jsonEncode(list));
      return Response(
        requestOptions: RequestOptions(path: '/user/suggest'),
        statusCode: 200,
        data: {'code': 0, 'msg': 'success', 'data': null},
      );
    }

    final response = await httpUtil.post(
      '/user/suggest',
      useCache: false,
      data: {
        'content': content
      }
    );

    return response;
  }
}
