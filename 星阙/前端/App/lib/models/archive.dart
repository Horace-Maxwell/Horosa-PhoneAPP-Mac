import 'dart:convert';

import 'package:horosa/models/bazi.dart';
import 'package:horosa/models/liu_ren.dart';
import 'package:horosa/models/qi_men.dart';
import 'package:horosa/pages/bazi/result.dart';
import 'package:horosa/pages/liuyao/result.dart';
import 'package:horosa/pages/liuren/result.dart';
import 'package:horosa/pages/qimen/result.dart';

import 'liu_lines.dart';

enum ArchiveType {
  bazi('八字', 1, BaZiResultPage.route),
  liuyao('六爻', 2, LiuYaoResultPage.route),
  liuren('六壬', 3, LiuRenResultPage.route),
  qimen('奇门', 4, QiMenResultPage.route);

  final String label;
  final int value;
  final String path;

  const ArchiveType(this.label, this.value, this.path);

  static ArchiveType getArchiveTypeByValue(int value) {
    ArchiveType? archiveType;
    for (ArchiveType type in ArchiveType.values) {
      if (type.value == value) {
        archiveType = type;
        break;
      }
    }
    return archiveType ?? ArchiveType.bazi;
  }
}

class ArchiveItem<T, U, V> {
  /// 其他配置
  final V extras;

  /// ID 编号
  final int id;

  /// 用户输入信息
  final T input;

  /// 输出结果信息
  final U output;

  /// 类型，1八字 2 六爻 3 六壬 4 奇门
  final int type;

  /// 1 自动 2 手动
  final int saveType;

  const ArchiveItem({
    required this.extras,
    required this.id,
    required this.input,
    required this.output,
    required this.type,
    required this.saveType,
  });

  factory ArchiveItem.fromJson(Map<String, dynamic> json) {
    return ArchiveItem(
      extras: json['extras'],
      id: json['id'],
      input: jsonDecode(json['input']),
      output: jsonDecode(json['output']),
      type: json['type'],
      saveType: json['save_type'],
    );
  }

  ArchiveItem<BaZiInput, BaZiResult, BaZiExtras> toBaZi() {
    return ArchiveItem(
      extras: BaZiExtras.fromJson(
        extras.runtimeType == String
            ? jsonDecode(extras as String) as Map<String, dynamic>
            : (extras as Map<dynamic, dynamic>).cast<String, dynamic>(),
      ),
      id: id,
      input: BaZiInput.fromJson(
          (input as Map<dynamic, dynamic>).cast<String, dynamic>()),
      output: BaZiResult.fromJson(
          (output as Map<dynamic, dynamic>).cast<String, dynamic>()),
      type: 1,
      saveType: saveType,
    );
  }

  ArchiveItem<LiuYaoInput, LiuYaoResult, LiuYaoExtras> toSixLine() {
    return ArchiveItem<LiuYaoInput, LiuYaoResult, LiuYaoExtras>(
      extras: LiuYaoExtras.fromJson(
        extras.runtimeType == String
            ? jsonDecode(extras as String) as Map<String, dynamic>
            : (extras as Map<dynamic, dynamic>).cast<String, dynamic>(),
      ),
      id: id,
      input: LiuYaoInput.from(
          (input as Map<dynamic, dynamic>).cast<String, dynamic>()),
      output: LiuYaoResult.from(
          (output as Map<dynamic, dynamic>).cast<String, dynamic>()),
      type: 2,
      saveType: saveType,
    );
  }

  ArchiveItem<LiuRenInput, LiuRenResult, LiuRenExtras> toLiuRen() {
    return ArchiveItem(
      extras: LiuRenExtras.fromJson(
        extras.runtimeType == String
            ? jsonDecode(extras as String) as Map<String, dynamic>
            : (extras as Map<dynamic, dynamic>).cast<String, dynamic>(),
      ),
      id: id,
      input: LiuRenInput.from(
          (input as Map<dynamic, dynamic>).cast<String, dynamic>()),
      output: LiuRenResult.from(
          (output as Map<dynamic, dynamic>).cast<String, dynamic>()),
      type: 3,
      saveType: saveType,
    );
  }

  ArchiveItem<QiMenInput, QiMenResult, QiMenExtras> toQiMen() {
    return ArchiveItem(
      extras: QiMenExtras.fromJson(
        extras.runtimeType == String
            ? jsonDecode(extras as String) as Map<String, dynamic>
            : (extras as Map<dynamic, dynamic>).cast<String, dynamic>(),
      ),
      id: id,
      input: QiMenInput.from(
          (input as Map<dynamic, dynamic>).cast<String, dynamic>()),
      output: QiMenResult.fromJson(
          (output as Map<dynamic, dynamic>).cast<String, dynamic>()),
      type: 4,
      saveType: saveType,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> i = input is Map ? input : (input as dynamic).toJson();
    return {
      'extras': extras is Map
          ? extras
          : extras is String
              ? jsonDecode(extras as String)
              : (extras as dynamic).toJson(),
      'id': id,
      'input': i,
      'output': output is Map ? output : (output as dynamic).toJson(),
      'type': type,
      'save_type': saveType,
      'input_key': i['input_key'],
    };
  }
}
