import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/constants/keys.dart';
import 'package:horosa/utils/http.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/utils/local_storage.dart';

class ArchiveSvc {
  static HTTPUtil httpUtil = HTTPUtil();
  static LocalStorage localStorage = LocalStorage();
  static final List<Map<String, dynamic>> _memoryArchives = [];

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  static Future<List<Map<String, dynamic>>> _readLocalArchives() async {
    try {
      final raw = await localStorage.read(AppKeys.localArchives);
      if (raw == null || raw.isEmpty) {
        return List<Map<String, dynamic>>.from(_memoryArchives);
      }
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return List<Map<String, dynamic>>.from(_memoryArchives);
      }
      final result = decoded
          .whereType<Map<dynamic, dynamic>>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
      _memoryArchives
        ..clear()
        ..addAll(result);
      return result;
    } catch (_) {
      return List<Map<String, dynamic>>.from(_memoryArchives);
    }
  }

  static Future<void> _writeLocalArchives(List<Map<String, dynamic>> items) async {
    _memoryArchives
      ..clear()
      ..addAll(items);
    try {
      await localStorage.write(AppKeys.localArchives, jsonEncode(items));
    } catch (_) {}
  }

  static Map<String, dynamic> _toServerArchiveItem(Map<String, dynamic> item) {
    return {
      'id': item['id'],
      'type': item['type'],
      'save_type': item['save_type'],
      'input': jsonEncode(item['input'] ?? {}),
      'output': jsonEncode(item['output'] ?? {}),
      'extras': jsonEncode(item['extras'] ?? {}),
      'input_key': item['input_key'],
    };
  }

  static Future<Response> getArchiveList({int page = 1, int size = 10}) async {
    if (LocalMode.enabled) {
      final all = await _readLocalArchives();
      all.sort((a, b) => _toInt(b['id']).compareTo(_toInt(a['id'])));
      final start = (page - 1) * size;
      final end = start + size > all.length ? all.length : start + size;
      final pageData = start >= all.length ? <Map<String, dynamic>>[] : all.sublist(start, end);
      return Response(
        requestOptions: RequestOptions(path: '/trigram/record_list'),
        statusCode: 200,
        data: {
          'code': 0,
          'msg': 'success',
          'data': {
            'data': pageData.map(_toServerArchiveItem).toList(),
            'total': all.length,
            'page': page,
            'page_size': size,
          }
        },
      );
    }

    final response = await httpUtil.post(
        baseUrl: 'https://api.horosa.com',
        '/trigram/record_list',
        useCache: false,
        data: {
          'page': page,
          'page_size': size,
        });

    return response;
  }

  static Future<Response> removeArchive(int id) async {
    if (LocalMode.enabled) {
      final all = await _readLocalArchives();
      all.removeWhere((item) => item['id'] == id);
      await _writeLocalArchives(all);
      return Response(
        requestOptions: RequestOptions(path: '/trigram/del_record'),
        statusCode: 200,
        data: {'code': 0, 'msg': 'success', 'data': null},
      );
    }

    final response = await httpUtil.post(
        '/trigram/del_record',
        useCache: false,
        data: {
          'id': id,
        }
    );

    return response;
  }

  /// 添加记录 | 修改记录 type 1八字 2 六爻 3 六壬 4 奇门
  static Future<Response> record(ArchiveItem item) async {
    if (LocalMode.enabled) {
      final all = await _readLocalArchives();
      final payload = item.toJson();
      final maxId = all.isEmpty
          ? 0
          : all.map((e) => _toInt(e['id'])).reduce((a, b) => a > b ? a : b);
      final nextId = maxId + 1;
      all.add({
        'id': nextId,
        'type': payload['type'] ?? item.type,
        'save_type': payload['save_type'] ?? item.saveType,
        'input': payload['input'] ?? {},
        'output': payload['output'] ?? {},
        'extras': payload['extras'] ?? {},
        'input_key': payload['input_key'],
      });
      await _writeLocalArchives(all);
      return Response(
        requestOptions: RequestOptions(path: '/trigram/add_record'),
        statusCode: 200,
        data: {
          'code': 0,
          'msg': 'success',
          'data': {'id': nextId},
        },
      );
    }

    final response = await httpUtil.post(
        '/trigram/add_record',
        useCache: false,
        data: item.toJson()
    );

    return response;
  }
}
