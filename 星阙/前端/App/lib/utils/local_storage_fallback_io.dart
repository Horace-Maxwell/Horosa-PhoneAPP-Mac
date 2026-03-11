import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'local_storage_fallback_base.dart';

class LocalStorageFallbackStoreImpl implements LocalStorageFallbackStore {
  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/horosa_local_storage.json');
  }

  @override
  Future<Map<String, String>> load() async {
    try {
      final file = await _file();
      if (!await file.exists()) {
        return {};
      }
      final raw = await file.readAsString();
      if (raw.isEmpty) {
        return {};
      }
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return {};
      }
      final result = <String, String>{};
      decoded.forEach((key, value) {
        if (key is String && value is String) {
          result[key] = value;
        }
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  @override
  Future<void> save(Map<String, String> data) async {
    try {
      final file = await _file();
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode(data));
    } catch (_) {}
  }
}
