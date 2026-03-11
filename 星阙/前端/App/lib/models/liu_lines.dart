import 'dart:convert';

import 'package:crypto/crypto.dart';

enum LineTypes {
  laoyang('老阳', 3, '9'),
  shaoyin('少阴', 1, '8'),
  shaoyang('少阳', -1, '7'),
  laoyin('老阴', -3, '6'),
  ;

  final int value;
  final String label;
  final String line;

  const LineTypes(this.label, this.value, this.line);

  static LineTypes getLineTypeByValue(int value) {
    LineTypes? lineType;
    for (LineTypes type in LineTypes.values) {
      if (type.value == value) {
        lineType = type;
        break;
      }
    }
    return lineType ?? LineTypes.laoyang;
  }

  static LineTypes getLineTypeByLine(String line) {
    LineTypes? lineType;
    for (LineTypes type in LineTypes.values) {
      if (type.line == line) {
        lineType = type;
        break;
      }
    }
    return lineType ?? LineTypes.laoyang;
  }
}

class LiuYaoInput {
  String? address;
  String? country;
  LiuYaoGuaTime guaTime;
  int guaType;
  Hseb hseb;
  String lines;
  String? jieqi;
  String? question;
  String? inputKey;
  int? isSave; // 是否保存 1 是 2 否

  LiuYaoInput({
    this.address,
    this.country,
    required this.guaTime,
    required this.guaType,
    required this.hseb,
    required this.lines,
    this.jieqi,
    this.question,
    this.inputKey,
    this.isSave,
  });

  factory LiuYaoInput.from(Map<String, dynamic> json) {
    return LiuYaoInput(
      address: json['address'],
      country: json['country'],
      guaTime: LiuYaoGuaTime.fromJson(json['gua_time']),
      guaType: json['gua_type'],
      hseb: Hseb.fromJson(json['hseb']),
      lines: json['lines'],
      jieqi: json['jieqi'],
      question: json['question'],
      inputKey: json['input_key'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> key = {
      'gua_time': guaTime.toJson(),
      'gua_type': guaType,
      'hseb': hseb.toJson(),
      'lines': lines,
      'jieqi': jieqi,
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
      'lines': lines,
      'jieqi': jieqi,
      'question': question,
      'input_key': inputKey ?? md5String,
      'is_save': isSave ?? 1,
    };
  }
}

class LiuYaoGuaTime {
  int year;
  int month;
  int day;
  int hour;
  int minute;

  LiuYaoGuaTime({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
  });

  factory LiuYaoGuaTime.fromJson(Map<String, dynamic> json) {
    return LiuYaoGuaTime(
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

class Hseb {
  String? day;
  String? hour;
  String? month;
  String? year;

  Hseb({
    this.day,
    this.hour,
    this.month,
    this.year,
  });

  factory Hseb.fromJson(Map<String, dynamic>? json) {
    return Hseb(
      day: json?['day'],
      hour: json?['hour'],
      month: json?['month'],
      year: json?['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'hour': hour,
      'month': month,
      'year': year,
    };
  }
}

class LiuYaoResult {
  ///变卦
  ChangeGua? changeGua;

  ///主卦
  Gua gua;

  ///记录id
  int? recordId;

  LiuYaoResult({
    required this.changeGua,
    required this.gua,
    this.recordId,
  });

  // 从JSON创建SixLinesResult对象的from方法
  factory LiuYaoResult.from(Map<String, dynamic> json) {
    return LiuYaoResult(
      changeGua: json['change_gua'] != null
          ? ChangeGua.from(json['change_gua'])
          : null,
      gua: Gua.from(json['gua']),
      recordId: json['record_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'change_gua': changeGua?.toJson(),
      'gua': gua.toJson(),
      'record_id': recordId ?? 0,
    };
  }
}

///变卦
class ChangeGua {
  List<String> dizhi;
  List<ChangeGuaFushen> fushen;
  String gong;
  String gua;
  String he;
  List<String> liuqin;
  List<String> liushou;
  String name;
  int shi;
  List<String> tiangan;
  String value;
  int ying;

  ChangeGua({
    required this.dizhi,
    required this.fushen,
    required this.gong,
    required this.gua,
    required this.he,
    required this.liuqin,
    required this.liushou,
    required this.name,
    required this.shi,
    required this.tiangan,
    required this.value,
    required this.ying,
  });

  // 从JSON创建ChangeGua对象的from方法
  factory ChangeGua.from(Map<String, dynamic> json) {
    return ChangeGua(
      dizhi: List<String>.from(json['dizhi']),
      fushen: (json['fushen'] as List)
          .map((item) => ChangeGuaFushen.from(item))
          .toList(),
      gong: json['gong'],
      gua: json['gua'],
      he: json['he'],
      liuqin: List<String>.from(json['liuqin']),
      liushou: List<String>.from(json['liushou']),
      name: json['name'],
      shi: json['shi'],
      tiangan: List<String>.from(json['tiangan']),
      value: json['value'],
      ying: json['ying'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dizhi': dizhi,
      'fushen': fushen.map((item) => item.toJson()).toList(),
      'gong': gong,
      'gua': gua,
      'he': he,
      'liuqin': liuqin,
      'liushou': liushou,
      'name': name,
      'shi': shi,
      'tiangan': tiangan,
      'value': value,
      'ying': ying,
    };
  }
}

class ChangeGuaFushen {
  int? index;
  String? name;

  ChangeGuaFushen({
    this.index,
    this.name,
  });

  // 从JSON创建ChangeGuaFushen对象的from方法
  factory ChangeGuaFushen.from(Map<String, dynamic> json) {
    return ChangeGuaFushen(
      index: json['index'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'name': name,
    };
  }
}

///主卦
class Gua {
  ///地址
  List<String> dizhi;

  ///伏神
  List<GuaFushen> fushen;

  ///卦宫
  String gong;

  ///卦名
  String gua;

  ///六冲 六合
  String he;

  ///六亲
  List<String> liuqin;

  ///六兽
  List<String> liushou;

  ///卦
  String name;

  ///世所在位置
  int shi;

  ///天干
  List<String> tiangan;

  ///卦的值
  String value;

  ///应所在位置
  int ying;

  Gua({
    required this.dizhi,
    required this.fushen,
    required this.gong,
    required this.gua,
    required this.he,
    required this.liuqin,
    required this.liushou,
    required this.name,
    required this.shi,
    required this.tiangan,
    required this.value,
    required this.ying,
  });

  // 从JSON创建Gua对象的from方法
  factory Gua.from(Map<String, dynamic> json) {
    return Gua(
      dizhi: List<String>.from(json['dizhi']),
      fushen:
          (json['fushen'] as List).map((item) => GuaFushen.from(item)).toList(),
      gong: json['gong'],
      gua: json['gua'],
      he: json['he'],
      liuqin: List<String>.from(json['liuqin']),
      liushou: List<String>.from(json['liushou']),
      name: json['name'],
      shi: json['shi'],
      tiangan: List<String>.from(json['tiangan']),
      value: json['value'],
      ying: json['ying'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dizhi': dizhi,
      'fushen': fushen.map((item) => item.toJson()).toList(),
      'gong': gong,
      'gua': gua,
      'he': he,
      'liuqin': liuqin,
      'liushou': liushou,
      'name': name,
      'shi': shi,
      'tiangan': tiangan,
      'value': value,
      'ying': ying,
    };
  }
}

class GuaFushen {
  ///伏神所在位置
  int index;

  ///伏神名称
  String name;

  GuaFushen({
    required this.index,
    required this.name,
  });

  // 从JSON创建GuaFushen对象的from方法
  factory GuaFushen.from(Map<String, dynamic> json) {
    return GuaFushen(
      index: json['index'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'name': name,
    };
  }
}

class Plum {
  final PlumGua gua;
  final PlumGua zongGua;
  final PlumGua huGua;
  final PlumGua changeGua;
  final PlumGua cuoGua;

  Plum({
    required this.gua,
    required this.zongGua,
    required this.huGua,
    required this.changeGua,
    required this.cuoGua,
  });

  // fromJson factory constructor
  factory Plum.fromJson(Map<String, dynamic> json) {
    return Plum(
      gua: PlumGua.fromJson(json['gua']),
      zongGua: PlumGua.fromJson(json['zong_gua']),
      huGua: PlumGua.fromJson(json['hu_gua']),
      changeGua: PlumGua.fromJson(json['change_gua']),
      cuoGua: PlumGua.fromJson(json['cuo_gua']),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'gua': gua.toJson(),
      'zong_gua': zongGua.toJson(),
      'hu_gua': huGua.toJson(),
      'change_gua': changeGua,
      'cuo_gua': cuoGua.toJson(),
    };
  }
}

class PlumGua {
  final String gong;
  final int ying;
  final String gua;
  final int shi;
  final String name;
  final String value;
  final String he;

  const PlumGua({
    required this.gong,
    required this.ying,
    required this.gua,
    required this.shi,
    required this.name,
    required this.value,
    required this.he,
  });

  // fromJson factory constructor
  factory PlumGua.fromJson(Map<String, dynamic> json) {
    return PlumGua(
      gong: json['gong'],
      ying: json['ying'],
      gua: json['gua'],
      shi: json['shi'],
      name: json['name'],
      value: json['value'],
      he: json['he'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'gong': gong,
      'ying': ying,
      'gua': gua,
      'shi': shi,
      'name': name,
      'value': value,
      'he': he,
    };
  }
}

class LiuYaoExtras {
  int? gender; // 卦主性别
  String? zodiac; // 卦主生肖
  Plum? plum;

  LiuYaoExtras({
    this.gender,
    this.zodiac,
    this.plum
  });

  // fromJson 方法，用于将 JSON 数据转换为 QiMenExtras 对象
  factory LiuYaoExtras.fromJson(Map<String, dynamic> json) {
    return LiuYaoExtras(
      gender: json['gender'],
      zodiac: json['zodiac'],
      plum: json['plum'] != null ? Plum.fromJson(json['plum']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'zodiac': zodiac,
      'plum': plum?.toJson(),
    };
  }
}