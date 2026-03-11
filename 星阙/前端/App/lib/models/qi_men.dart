import 'dart:convert';

import 'package:crypto/crypto.dart';

enum QiMenType {
  chaibu('拆补', 1),
  zhirun('置润', 2);

  final int value;
  final String label;

  const QiMenType(this.label, this.value);
}

class QiMenInput {
  ///地址
  String? address;

  ///国家
  String? country;

  ///卦时间
  QiMenGuaTime guaTime;

  ///卦排盘，1 三宫 2 横排
  int guaType;

  ///问题
  String? question;

  String? inputKey;

  int? isSave; // 是否保存 1 是 2 否

  QiMenInput({
    this.address,
    this.country,
    required this.guaTime,
    required this.guaType,
    this.question,
    this.inputKey,
    this.isSave,
  });

  factory QiMenInput.from(Map<String, dynamic> json) {
    return QiMenInput(
      address: json['address'],
      country: json['country'],
      guaTime: QiMenGuaTime.fromJson(json['gua_time']),
      guaType: json['gua_type'],
      question: json['question'],
      inputKey: json['input_key'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> key = {
      'gua_time': guaTime.toJson(),
      'gua_type': guaType,
    };
    List<int> bytes = utf8.encode(key.toString());
    Digest md5Hash = md5.convert(bytes);
    String md5String = md5Hash.toString();
    return {
      'address': address,
      'country': country,
      'gua_time': guaTime.toJson(),
      'gua_type': guaType,
      'question': question,
      'input_key': inputKey ?? md5String,
      'is_save': isSave ?? 1,
    };
  }
}

class QiMenGuaTime {
  int year;
  int month;
  int day;
  int hour;
  int minute;

  QiMenGuaTime({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
  });

  factory QiMenGuaTime.fromJson(Map<String, dynamic> json) {
    return QiMenGuaTime(
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

class QiMenResult {
  final Map<String, String> tianpan;
  final Zhifushi zhifushi;
  final Map<String, String> xing;
  final String paiju;
  final Map<String, int> dipanMap;
  final Map<String, String> men;
  final Map<String, String> dipan;
  final Map<String, String> shen;
  final Xunkong xunkong;

  const QiMenResult({
    required this.tianpan,
    required this.zhifushi,
    required this.xing,
    required this.paiju,
    required this.dipanMap,
    required this.men,
    required this.dipan,
    required this.shen,
    required this.xunkong,
  });

  // fromJson 方法，用于将 JSON 数据转换为 Tianpan 对象
  factory QiMenResult.fromJson(Map<String, dynamic> json) {
    return QiMenResult(
      tianpan: Map<String, String>.from(json['tianpan']),
      zhifushi: Zhifushi.fromJson(json['zhifushi']),
      xing: Map<String, String>.from(json['xing']),
      paiju: json['paiju'],
      dipanMap: Map<String, int>.from(json['dipan_map']),
      men: Map<String, String>.from(json['men']),
      dipan: Map<String, String>.from(json['dipan']),
      shen: Map<String, String>.from(json['shen']),
      xunkong: Xunkong.fromJson(json['xunkong']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tianpan': tianpan,
      'zhifushi': zhifushi.toJson(),
      'xing': xing,
      'paiju': paiju,
      'dipan_map': dipanMap,
      'men': men,
      'dipan': dipan,
      'shen': shen,
      'xunkong': xunkong.toJson(),
    };
  }
}

class Zhifushi {
  final String xing;
  final String shi;

  Zhifushi({
    required this.xing,
    required this.shi,
  });

  // fromJson 方法，用于将 JSON 数据转换为 Zhifushi 对象
  factory Zhifushi.fromJson(Map<String, dynamic> json) {
    return Zhifushi(
      xing: json['xing'],
      shi: json['shi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'xing': xing,
      'shi': shi,
    };
  }
}

class Xunkong {
  final List<int> shikong;
  final List<int> rikong;

  Xunkong({
    required this.shikong,
    required this.rikong,
  });

  // fromJson 方法，用于将 JSON 数据转换为 Xunkong 对象
  factory Xunkong.fromJson(Map<String, dynamic> json) {
    return Xunkong(
      shikong: List<int>.from(json['时空']),
      rikong: List<int>.from(json['日空']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '时空': shikong,
      '日空': rikong,
    };
  }
}

class QiMenExtras {
  int? seal;
  int? gender; // 卦主性别
  String? zodiac; // 卦主生肖


  QiMenExtras({
    this.seal,
    this.gender,
    this.zodiac
  });

  // fromJson 方法，用于将 JSON 数据转换为 QiMenExtras 对象
  factory QiMenExtras.fromJson(Map<String, dynamic> json) {
    return QiMenExtras(
      seal: json['seal'],
      gender: json['gender'],
      zodiac: json['zodiac'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seal': seal,
      'gender': gender,
      'zodiac': zodiac,
    };
  }
}