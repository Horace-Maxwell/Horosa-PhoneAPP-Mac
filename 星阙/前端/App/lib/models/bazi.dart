import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:lunar/lunar.dart';
import 'gender.dart';

class BirthPlace {
  /// 国家
  final String country;
  /// 地区
  final String place;
  /// 时区
  final String timezone;
  /// 时区偏移
  final int gmtOffset;
  /// 经度
  final double longitude;


  const BirthPlace({required this.country, required this.place, required this.timezone, required this.gmtOffset, required this.longitude});

  @override
  String toString() {
    return '$country $place';
  }

  factory BirthPlace.fromJson(Map<String, dynamic> json) {
    return BirthPlace(
      country: json['country'],
      place: json['place'],
      timezone: json['timezone'],
      gmtOffset: json['gmtOffset'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'place': place,
      'timezone': timezone,
      'gmtOffset': gmtOffset,
      'longitude': longitude,
    };
  }
}

class BaZiInput {
  /// 姓名
  final String username;
  /// 性别
  final Gender gender;
  /// 生日
  final Solar birthday;
  /// 真太阳时
  final bool useAST;
  /// 出生地区
  final BirthPlace birthplace;

  final String? inputKey;

  const BaZiInput({ required this.username, required this.gender, required this.birthday, required this.birthplace, required this.useAST, this.inputKey});

  @override
  String toString() {
    return '$inputKey $username ${gender.label} ${birthday.toFullString()}';
  }

  factory BaZiInput.fromJson(Map<String, dynamic> json) {
    return BaZiInput(
      username: json['username'],
      gender: Gender.getByValue(json['gender'] as int) ?? Gender.male,
      birthday: Solar.fromDate(DateTime.parse(json['birthday'])),
      birthplace: BirthPlace.fromJson(json['birthplace']),
      useAST: json['use_ast'] == 1,
      inputKey: json['input_key'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> key = {
      'username': username,
      'gender': gender.value,
      'birthday': birthday.toYmdHms(),
      'birthplace': birthplace.toJson(),
      'use_ast': useAST ? 1 : 0,
    };
    List<int> bytes = utf8.encode(key.toString());
    Digest md5Hash = md5.convert(bytes);
    String md5String = md5Hash.toString();

    return {
      'username': username,
      'gender': gender.value,
      'birthday': birthday.toYmdHms(),
      'birthplace': birthplace.toJson(),
      'use_ast': useAST ? 1 : 0,
      'input_key': inputKey ?? md5String,
    };
  }
}

class BaZi extends Lunar {
  final Lunar lunar;

  BaZi(this.lunar) : super.fromSolar(lunar.getSolar());

  String getSolarToStr() {
    Solar solar = lunar.getSolar();
    int year = solar.getYear();
    String month = solar.getMonth().toString().padLeft(2, '0');
    String day = solar.getDay().toString().padLeft(2, '0');
    String hour = solar.getHour().toString().padLeft(2, '0');
    String minute = solar.getMinute().toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  String getLunarToStr() {
    String year = lunar.getYearInChinese();
    String month = lunar.getMonthInChinese();
    String day = lunar.getDayInChinese();
    String time = lunar.getTimeZhi();
    return '$year年$month月$day $time时';
  }
}

extension SolarOperations on Solar {
  Solar prevHour(int hours) {
    int h = getHour() - hours;
    int n = h < 0 ? -1 : 1;
    int hour = h.abs();
    int days = (hour / 24).floor() * n;
    hour = (hour % 24) * n;
    if (hour < 0) {
      hour += 24;
      days--;
    }
    Solar solar = next(days);
    return Solar.fromYmdHms(solar.getYear(), solar.getMonth(), solar.getDay(), hour, solar.getMinute(), solar.getSecond());
  }

  String toYmdInChinese() {
    return '${getYear()}年${getMonth().toString().padLeft(2, '0')}月${getDay().toString().padLeft(2, '0')}日';
  }
}

class BaZiResult {

  const BaZiResult();

  factory BaZiResult.fromJson(Map<String, dynamic> json) {
    return const BaZiResult();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class BaZiExtras {

  const BaZiExtras();

  factory BaZiExtras.fromJson(Map<String, dynamic> json) {
    return const BaZiExtras();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}