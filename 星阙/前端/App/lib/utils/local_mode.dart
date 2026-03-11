import 'package:flutter/foundation.dart';
import 'package:horosa/models/user_info.dart';

class LocalMode {
  // Desktop/web/iPhone local run: no login required.
  static bool get enabled =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.iOS;

  static UserInfo guestUser() {
    return UserInfo(
      id: 0,
      avatar: '',
      name: '本地访客',
      sex: 1,
      birthday: '',
      residenceProvinceId: 99000000,
      residenceCityId: 99010000,
      residenceDistrictId: 99010100,
      birthProvinceId: 99000000,
      birthCityId: 99010000,
      birthDistrictId: 99010100,
    );
  }
}
