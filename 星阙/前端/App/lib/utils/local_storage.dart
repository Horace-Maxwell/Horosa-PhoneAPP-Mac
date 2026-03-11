import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'local_storage_fallback.dart';

class LocalStorage {
  // 私有构造函数
  LocalStorage._privateConstructor();

  // 唯一实例
  static final LocalStorage _instance = LocalStorage._privateConstructor();

  // 工厂构造函数，返回唯一实例
  factory LocalStorage() {
    return _instance;
  }

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static final Map<String, String> _fallbackMemory = {};
  static bool _fallbackLoaded = false;
  static final _fallbackStore = createLocalStorageFallbackStore();

  Future<void> _loadFallbackIfNeeded() async {
    if (_fallbackLoaded) {
      return;
    }
    _fallbackLoaded = true;
    try {
      final loaded = await _fallbackStore.load();
      _fallbackMemory
        ..clear()
        ..addAll(loaded);
    } catch (_) {}
  }

  Future<void> _flushFallback() async {
    try {
      await _fallbackStore.save(_fallbackMemory);
    } catch (_) {}
  }

  // 存储数据
  Future<void> write(String key, String value) async {
    await _loadFallbackIfNeeded();
    _fallbackMemory[key] = value;
    await _flushFallback();
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {}
  }

  // 读取数据
  Future<String?> read(String key) async {
    await _loadFallbackIfNeeded();
    try {
      final value = await _storage.read(key: key);
      return value ?? _fallbackMemory[key];
    } catch (_) {
      return _fallbackMemory[key];
    }
  }

  // 删除数据
  Future<void> delete(String key) async {
    await _loadFallbackIfNeeded();
    _fallbackMemory.remove(key);
    await _flushFallback();
    try {
      await _storage.delete(key: key);
    } catch (_) {}
  }

  // 清除所有数据
  Future<void> deleteAll() async {
    await _loadFallbackIfNeeded();
    _fallbackMemory.clear();
    await _flushFallback();
    try {
      await _storage.deleteAll();
    } catch (_) {}
  }
}
