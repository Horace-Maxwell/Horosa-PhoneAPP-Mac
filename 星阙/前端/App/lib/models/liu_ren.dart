import 'dart:convert';

import 'package:crypto/crypto.dart';

class LiuRenInput {
  ///地址
  String? address;

  ///国家
  String? country;

  ///卦时间
  GuaTime guaTime;

  ///卦排盘，1 三宫 2 横排
  int guaType;

  ///活时，数字
  int? hourNum;

  ///天干地支
  LiuRenHseb hseb;

  ///节气
  String? jieqi;

  ///农历月份
  String? month;

  ///问题
  String? question;

  String? inputKey;

  int? isSave; // 是否保存 1 是 2 否

  LiuRenInput({
    this.address,
    this.country,
    required this.guaTime,
    required this.guaType,
    required this.hseb,
    this.jieqi,
    this.month,
    this.question,
    this.hourNum,
    this.inputKey,
    this.isSave,
  });

  factory LiuRenInput.from(Map<String, dynamic> json) {
    return LiuRenInput(
      address: json['address'],
      country: json['country'],
      guaTime: GuaTime.fromJson(json['gua_time']),
      guaType: json['gua_type'],
      hseb: LiuRenHseb.fromJson(json['hseb']),
      hourNum: json['hour_num'],
      jieqi: json['jieqi'],
      month: json['month'],
      question: json['question'],
      inputKey: json['input_key'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> key = {
      'gua_time': guaTime.toJson(),
      'gua_type': guaType,
      'hseb': hseb.toJson(),
      'hour_num': hourNum,
      'jieqi': jieqi,
      'month': month,
    };
    List<int> bytes = utf8.encode(key.toString());
    Digest md5Hash = md5.convert(bytes);
    String md5String = md5Hash.toString();

    return {
      'address': address,
      'country': country,
      'gua_time': guaTime.toJson(),
      'gua_type': guaType,
      'hseb': hseb.toJson(),
      'hour_num': hourNum,
      'jieqi': jieqi,
      'month': month,
      'question': question,
      'input_key': inputKey ?? md5String,
      'is_save': isSave ?? 1,
    };
  }
}

class GuaTime {
  int year;
  int month;
  int day;
  int hour;
  int minute;

  GuaTime({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
  });

  factory GuaTime.fromJson(Map<String, dynamic> json) {
    return GuaTime(
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'minute': minute,
    };
  }

  @override
  String toString() {
    return '$year年${month.toString().padLeft(2, '0')}月${day.toString().padLeft(2, '0')}日 ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

class LiuRenHseb {
  String? day;
  String? hour;

  LiuRenHseb({
    this.day,
    this.hour,
  });

  factory LiuRenHseb.fromJson(Map<String, dynamic>? json) {
    return LiuRenHseb(
      day: json?['day'],
      hour: json?['hour'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'hour': hour
    };
  }
}

class LiuRenResult {
  /// 格局
  List<String> geju;

  /// 记录id
  int? id;

  /// 三传
  Map<String, dynamic> sanchuan;

  /// 四课
  Map<String, String> sike;

  ///天将
  Map<String, String> tianjiang;

  ///天盘
  Map<String, String> tianpan;

  ///天干
  Map<String, String> tiangan;

  ///月将
  String yuejiang;

  LiuRenResult({
    this.id,
    required this.geju,
    required this.sanchuan,
    required this.sike,
    required this.tianjiang,
    required this.tianpan,
    required this.tiangan,
    required this.yuejiang,
  });

  // 从JSON创建ChangeGua对象的from方法
  factory LiuRenResult.from(Map<String, dynamic> json) {
    return LiuRenResult(
      id: json['id'],
      geju: List<String>.from(json['geju']),
      sanchuan: Map<String, String>.from(json['sanchuan']),
      sike: Map<String, String>.from(json['sike']),
      tianjiang: Map<String, String>.from(json['tianjiang']),
      tianpan:Map<String, String>.from(json['tianpan']),
      tiangan: Map<String, String>.from(json['tiangan']),
      yuejiang: json['yuejiang'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'geju': geju,
      'sanchuan': sanchuan,
      'sike': sike,
      'tianjiang': tianjiang,
      'tianpan': tianpan,
      'tiangan': tiangan,
      'yuejiang': yuejiang,
    };
  }
}

class LiuRenExtras {
  int? gender; // 卦主性别
  String? zodiac; // 卦主生肖

  LiuRenExtras({
    this.gender,
    this.zodiac
  });

  // fromJson 方法，用于将 JSON 数据转换为 QiMenExtras 对象
  factory LiuRenExtras.fromJson(Map<String, dynamic> json) {
    return LiuRenExtras(
      gender: json['gender'],
      zodiac: json['zodiac'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'zodiac': zodiac,
    };
  }
}