abstract class LocalStorageFallbackStore {
  Future<Map<String, String>> load();
  Future<void> save(Map<String, String> data);
}
