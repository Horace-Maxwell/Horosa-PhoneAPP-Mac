import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:horosa/constants/keys.dart';
import 'package:horosa/models/user_info.dart';
import 'package:horosa/utils/http.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/utils/local_storage.dart';

class ProfileSvc {
  static HTTPUtil httpUtil = HTTPUtil();
  static LocalStorage localStorage = LocalStorage();

  static Future<void> _writeLocalUserInfo(UserInfo userInfo) {
    return localStorage.write(AppKeys.localUserInfo, jsonEncode(userInfo.toJson()));
  }

  static Future<UserInfo> _readLocalUserInfo() async {
    final raw = await localStorage.read(AppKeys.localUserInfo);
    if (raw == null || raw.isEmpty) {
      final guest = LocalMode.guestUser();
      await _writeLocalUserInfo(guest);
      return guest;
    }
    return UserInfo.fromJson((jsonDecode(raw) as Map<dynamic, dynamic>).cast<String, dynamic>());
  }

  static Future<List<Relation>> _readLocalRelations() async {
    final raw = await localStorage.read(AppKeys.localRelationBook);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return [];
    }
    return decoded
        .map((e) => Relation.fromJson((e as Map<dynamic, dynamic>).cast<String, dynamic>()))
        .toList();
  }

  static Future<void> _writeLocalRelations(List<Relation> relations) {
    return localStorage.write(
      AppKeys.localRelationBook,
      jsonEncode(relations.map((r) => r.toJson()).toList()),
    );
  }

  /// 注册账号
  static Future<Response> register(String username, String password, String confirmPassword) async {
    if (LocalMode.enabled) {
      return Response(
        requestOptions: RequestOptions(path: '/user/register'),
        statusCode: 200,
        data: {
          'code': 0,
          'msg': 'success',
          'data': {'token': 'LOCAL_GUEST_TOKEN'}
        },
      );
    }

    final response = await httpUtil.post(
      '/user/register',
      useCache: false,
      useAuth: false,
      data: {
        'username': username,
        'password': password,
        'confirm_password': confirmPassword
      }
    );

    return response;
  }

  /// 账号登录
  static Future<Response> login(String username, String password) async {
    if (LocalMode.enabled) {
      return Response(
        requestOptions: RequestOptions(path: '/user/login'),
        statusCode: 200,
        data: {
          'code': 0,
          'msg': 'success',
          'data': {'token': 'LOCAL_GUEST_TOKEN'}
        },
      );
    }

    final response = await httpUtil.post(
      '/user/login',
      useCache: false,
      useAuth: false,
      data: {
        'username': username,
        'password': password
      }
    );

    return response;
  }

  /// 获取用户信息
  static Future<Response> getUserInfo() async {
    if (LocalMode.enabled) {
      final user = await _readLocalUserInfo();
      return Response(
        requestOptions: RequestOptions(path: '/user/info'),
        statusCode: 200,
        data: {
          'code': 0,
          'msg': 'success',
          'data': user.toJson(),
        },
      );
    }

    final response = await httpUtil.post(
      '/user/info',
      useCache: false,
    );

    return response;
  }

  /// 修改用户信息
  static Future<Response> updateUserInfo(UserInfo userInfo) async {
    if (LocalMode.enabled) {
      await _writeLocalUserInfo(userInfo);
      return Response(
        requestOptions: RequestOptions(path: '/user/modify'),
        statusCode: 200,
        data: {'code': 0, 'msg': 'success', 'data': userInfo.toJson()},
      );
    }

    final response = await httpUtil.post(
      '/user/modify',
      useCache: false,
      data: userInfo.toJson()
    );

    return response;
  }

  /// 注销用户
  static Future<Response> deregister() async {
    if (LocalMode.enabled) {
      await localStorage.delete(AppKeys.localUserInfo);
      await localStorage.delete(AppKeys.localRelationBook);
      await localStorage.delete(AppKeys.localArchives);
      await localStorage.delete(AppKeys.accessToken);
      return Response(
        requestOptions: RequestOptions(path: 'cancel_user'),
        statusCode: 200,
        data: {'code': 0, 'msg': 'success', 'data': null},
      );
    }

    final response = await httpUtil.post(
        'cancel_user',
        useCache: false,
    );

    return response;
  }

  /// 获取起卦列表
  static Future<Response>  getRelationBook({int page = 1, int size = 10}) async {
    if (LocalMode.enabled) {
      final all = await _readLocalRelations();
      all.sort((a, b) => ((b.id ?? 0).compareTo(a.id ?? 0)));
      final start = (page - 1) * size;
      final end = start + size > all.length ? all.length : start + size;
      final pageData = start >= all.length ? <Relation>[] : all.sublist(start, end);
      return Response(
        requestOptions: RequestOptions(path: '/trigram_book/list'),
        statusCode: 200,
        data: {
          'code': 0,
          'msg': 'success',
          'data': {
            'data': pageData.map((r) => r.toJson()).toList(),
            'total': all.length,
            'page': page,
            'page_size': size,
          }
        },
      );
    }

    final response = await httpUtil.post(
        '/trigram_book/list',
        useCache: false,
        data: {
          'page': page,
          'page_size': size,
        });

    return response;
  }

  /// 创建起卦人
  static Future<Response> createRelation(Relation relation) async {
    if (LocalMode.enabled) {
      final all = await _readLocalRelations();
      final maxId = all.isEmpty
          ? 0
          : all.map((r) => r.id ?? 0).reduce((a, b) => a > b ? a : b);
      relation.id = maxId + 1;
      all.add(relation);
      await _writeLocalRelations(all);
      return Response(
        requestOptions: RequestOptions(path: '/trigram_book/add'),
        statusCode: 200,
        data: {'code': 0, 'msg': 'success', 'data': relation.toJson()},
      );
    }

    final response = await httpUtil.post(
        '/trigram_book/add',
        useCache: false,
        data: relation.toJson()
    );

    return response;
  }

  /// 修改起卦人
  static Future<Response> updateRelation(Relation relation) async {
    if (LocalMode.enabled) {
      final all = await _readLocalRelations();
      final index = all.indexWhere((r) => r.id == relation.id);
      if (index == -1) {
        return Response(
          requestOptions: RequestOptions(path: '/trigram_book/modify'),
          statusCode: 200,
          data: {'code': 1, 'msg': '目标不存在', 'data': null},
        );
      }
      all[index] = relation;
      await _writeLocalRelations(all);
      return Response(
        requestOptions: RequestOptions(path: '/trigram_book/modify'),
        statusCode: 200,
        data: {'code': 0, 'msg': 'success', 'data': relation.toJson()},
      );
    }

    final response = await httpUtil.post(
        '/trigram_book/modify',
        useCache: false,
        data: relation.toJson()
    );

    return response;
  }

  /// 删除起卦人
  static Future<Response> removeRelation(int id) async {
    if (LocalMode.enabled) {
      final all = await _readLocalRelations();
      all.removeWhere((r) => r.id == id);
      await _writeLocalRelations(all);
      return Response(
        requestOptions: RequestOptions(path: '/trigram_book/del'),
        statusCode: 200,
        data: {'code': 0, 'msg': 'success', 'data': null},
      );
    }

    final response = await httpUtil.post(
        '/trigram_book/del?id=$id',
        useCache: false,
        data: {'id': id}
    );

    return response;
  }
}
