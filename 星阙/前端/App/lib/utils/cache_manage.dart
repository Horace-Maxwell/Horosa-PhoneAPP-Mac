import 'package:path_provider/path_provider.dart';
import 'log.dart';

class CacheManager {
  /// 清除缓存文件夹下的所有文件
  Future<void> clearCache() async {
    try {
      // 获取临时目录
      final cacheDir = await getTemporaryDirectory();
      // 获取应用支持目录（缓存文件通常存储在此处）
      final appSupportDir = await getApplicationSupportDirectory();

      // 删除缓存目录下的所有文件和子目录
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }
      // 删除应用支持目录下的所有文件和子目录
      if (appSupportDir.existsSync()) {
        appSupportDir.deleteSync(recursive: true);
      }
      Log.d("缓存清理完成");
    } catch (e) {
      Log.d("清除缓存时出错: $e");
    }
  }
}