import 'package:flutter/widgets.dart';
import 'package:horosa/models/user_info.dart';
import 'package:horosa/services/profile.dart';
import 'package:horosa/utils/local_storage.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/constants/keys.dart';

LocalStorage _localStorage = LocalStorage();

class AuthProvider extends ChangeNotifier {
  // 是否需要提示用户登录
  bool needRemind = true;

  String? token;
  UserInfo? userInfo;

  bool get isLoggedIn => LocalMode.enabled || (token != null && userInfo != null);

  AuthProvider() {
    if (LocalMode.enabled) {
      needRemind = false;
      token = 'LOCAL_GUEST_TOKEN';
      userInfo = LocalMode.guestUser();
    }
    _loadTokenFromStorage();
  }

  Future<void> _loadTokenFromStorage() async {
    if (LocalMode.enabled) {
      needRemind = false;
      setToken('LOCAL_GUEST_TOKEN');
      setUserInfo(userInfo ?? LocalMode.guestUser());
      notifyListeners();
      return;
    }

    String? token = await _localStorage.read(AppKeys.accessToken);
    if(token != null) {
      setToken(token);
    }
    if(token != null && userInfo == null) {
      ProfileSvc.getUserInfo().then((res) {
        if(res.data['code'] == 10401) {
          _localStorage.delete(AppKeys.accessToken);
          setToken(null);
          setUserInfo(null);
          return;
        }
        if(res.data['code'] == 0) {
          setUserInfo(UserInfo.fromJson(res.data['data'] as Map<String, dynamic>));
        }
      });
    }
    notifyListeners();
  }

  void setToken(String? newToken) {
    if (LocalMode.enabled && (newToken == null || newToken.isEmpty)) {
      token = 'LOCAL_GUEST_TOKEN';
      notifyListeners();
      return;
    }
    token = newToken;
    notifyListeners();
  }

  void setUserInfo(UserInfo? newUserInfo) {
    if (LocalMode.enabled && newUserInfo == null) {
      userInfo = LocalMode.guestUser();
      notifyListeners();
      return;
    }
    userInfo = newUserInfo;
    notifyListeners();
  }

  void setNeedRemind(bool newNeedRemind) {
    if (LocalMode.enabled) {
      needRemind = false;
      notifyListeners();
      return;
    }
    needRemind = newNeedRemind;
    notifyListeners();
  }
}
