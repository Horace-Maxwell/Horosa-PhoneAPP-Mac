import 'local_storage_fallback_base.dart';

class LocalStorageFallbackStoreImpl implements LocalStorageFallbackStore {
  @override
  Future<Map<String, String>> load() async => {};

  @override
  Future<void> save(Map<String, String> data) async {}
}
