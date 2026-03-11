import 'local_storage.dart';
import 'package:horosa/constants/keys.dart';

LocalStorage _localStorage = LocalStorage();

Future<bool> isFirstLaunch() async {
  String? firstLaunch = await _localStorage.read(AppKeys.firstLaunch);
  if (firstLaunch == null || firstLaunch == 'true') {
    return true;
  }
  return false;
}

Future<void> setFirstLaunch() async {
  await _localStorage.write(AppKeys.firstLaunch, 'false');
}