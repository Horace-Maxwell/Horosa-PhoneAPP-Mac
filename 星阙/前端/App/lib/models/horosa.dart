import 'dart:math';
import 'dart:ui';

import 'package:horosa/utils/cyclic_sort.dart';
import 'package:lunar/lunar.dart';
import 'package:horosa/styles/colors.dart';

Lunar _lunar = Lunar.fromDate(DateTime.now());

class Horosa {
  // 节气
  static getSolarTerms() {
    return _lunar.getPrevJieQi(true).getName();
  }

  // 阴历月、日
  static getLunarMD() {
    return '${_lunar.getMonthInChinese()}月${_lunar.getDayInChinese()}';
  }

  // 四柱
  static getEightCharsDateYMDH() {
    return '${_lunar.getYearInGanZhi()}年 ${_lunar
        .getMonthInGanZhi()}月 ${_lunar.getDayInGanZhi()}日 ${_lunar
        .getTimeInGanZhi()}时';
  }

  // 二十八星宿
  static getMansion() {
    return _lunar.getXiu() + _lunar.getZheng() + _lunar.getAnimal();
  }

  // 宜
  static String getDailyYi() {
    return _lunar
        .getDayYi()
        .first;
  }

  // 忌
  static String getDailyJi() {
    return _lunar
        .getDayJi()
        .first;
  }

  // 藏干
  static List<String> getHiddenStems(String branch) {
    return LunarUtil.ZHI_HIDE_GAN[branch]!;
  }

  // 根据 Stems 获取十神
  static String getShiShenByBothOfStems(StemsOrBranchElement a,
      StemsOrBranchElement b) {
    return LunarUtil.SHI_SHEN['${a.label}${b.label}']!;
  }

  // 根据 StemsAndBranch String 获取十神
  static String getShiShenBySABStr(String sab) {
    return LunarUtil.SHI_SHEN[sab]!;
  }

  // 根据 Stems 和 Branch 获取十神
  static List<String> getShiShenBySAB(Stems s, Branches b) {
    List<String> hiddenStems = getHiddenStems(b.label);
    List<String> l = <String>[];
    for (String gan in hiddenStems) {
      l.add(LunarUtil.SHI_SHEN['${s.label}$gan']!);
    }
    return l;
  }

  // 根据 Stems 和 Branch 获取纳音
  static String getNaYinBySAB(StemsOrBranchElement s, StemsOrBranchElement b) =>
      LunarUtil.NAYIN['${s.label}${b.label}']!;

  // 根据 Stems 和 Branch 获取旬空
  static String getXunKongBySAB(StemsOrBranchElement s,
      StemsOrBranchElement b) => LunarUtil.getXunKong('${s.label}${b.label}');

  // 获取自坐
  static String getSelfZuo(StemsOrBranchElement stems,
      StemsOrBranchElement branch) {
    int? offset = EightChar.CHANG_SHENG_OFFSET[stems.label];
    int index = (offset! +
        ((stems.value - 1) % 2 == 0 ? branch.value - 1 : -(branch.value - 1)))
        .toInt();
    if (index >= 12) {
      index -= 12;
    }
    if (index < 0) {
      index += 12;
    }
    return EightChar.CHANG_SHENG[index];
  }
}

/// 五行关系
enum FivePhasesRelS {
  beControlled, // 被克
  control, // 克
  beProduced, // 被生
  produce, // 生
  same, // 同
  none; // 无关系
}

/// 五行
enum FivePhases {
  wood(label: '木', color: WuXingColors.wood, value: 0),
  fire(label: '火', color: WuXingColors.fire, value: 1),
  earth(label: '土', color: WuXingColors.earth, value: 2),
  metal(label: '金', color: WuXingColors.metal, value: 3),
  water(label: '水', color: WuXingColors.water, value: 4);

  final String label;
  final Color color;
  final int value;

  const FivePhases(
      {required this.label, required this.color, required this.value});

  static FivePhasesRelS getBothOfInteraction(FivePhases a, FivePhases b) {
    if (a.value == b.value) {
      return FivePhasesRelS.same;
    }

    if (a
        .getGenerating()
        .value == b.value) {
      return FivePhasesRelS.produce;
    }

    if (b
        .getGenerating()
        .value == a.value) {
      return FivePhasesRelS.beProduced;
    }

    if (a
        .getOvercoming()
        .value == b.value) {
      return FivePhasesRelS.beControlled;
    }

    if (b
        .getOvercoming()
        .value == a.value) {
      return FivePhasesRelS.control;
    }

    return FivePhasesRelS.none;
  }

  FivePhases getGenerating() {
    int value = (this.value + 1) % 5;
    return FivePhases.values[value];
  }

  FivePhases getOvercoming() {
    int value = (this.value - 2) % 5;
    if (value < 0) value += 5;
    return FivePhases.values[value];
  }
}

abstract class StemsOrBranchElement {
  String get label;

  FivePhases get element;

  int get value;
}

class StemsBranchItem {
  final Stems? stems;
  final Branches? branch;

  const StemsBranchItem({this.stems, this.branch});

  String getNaYin() {
    if (stems == null || branch == null) {
      throw "stems and branch which can't be empty.";
    }
    return LunarUtil.NAYIN['${stems?.label}${branch?.label}']!;
  }

  @override
  String toString() {
    return '${stems?.label ?? ''}${branch?.label ?? ''}';
  }
}

/// 天干地支关系
enum SOBRelShip {
  combination(1, label: '合'),
  conflict(-1, label: '冲'),
  none(0);

  final int value;
  final String? label;

  const SOBRelShip(this.value, {this.label});
}

class SOBCombOrConflict {
  final String label;
  final int value;
  final Color color;

  const SOBCombOrConflict(
      {required this.label, required this.value, required this.color});
}

/// 干或支相合
class SOBCombination {
  final StemsOrBranchElement a;
  final StemsOrBranchElement b;
  final FivePhases combination;

  const SOBCombination(this.a, this.b, this.combination);

  @override
  String toString() {
    return '${a.label}${b.label}合化${combination.label}';
  }
}

/// 干或支相冲
class SOBConflict {
  final StemsOrBranchElement a;
  final StemsOrBranchElement b;

  const SOBConflict(this.a, this.b);

  @override
  String toString() {
    return '${a.label}${b.label}相冲';
  }
}

/// 天干
enum Stems implements StemsOrBranchElement {
  jia(label: '甲', element: FivePhases.wood, value: 1),
  yi(label: '乙', element: FivePhases.wood, value: 2),
  bing(label: '丙', element: FivePhases.fire, value: 3),
  ding(label: '丁', element: FivePhases.fire, value: 4),
  wu(label: '戊', element: FivePhases.earth, value: 5),
  ji(label: '己', element: FivePhases.earth, value: 6),
  geng(label: '庚', element: FivePhases.metal, value: 7),
  xin(label: '辛', element: FivePhases.metal, value: 8),
  ren(label: '壬', element: FivePhases.water, value: 9),
  gui(label: '癸', element: FivePhases.water, value: 10);

  @override
  final String label;
  @override
  final FivePhases element;
  @override
  final int value;

  const Stems(
      {required this.label, required this.element, required this.value});

  static Stems getStemsByValue(int value) {
    return Stems.values.firstWhere((stems) => value == stems.value);
  }

  static Stems getStemsByLabel(String value) {
    return Stems.values.firstWhere((stems) => value == stems.label);
  }

  static SOBRelShip getBothOfStemsRS(StemsOrBranchElement a,
      StemsOrBranchElement b) {
    if (((a.value - b.value).abs() % 10 == 6)) {
      return SOBRelShip.conflict;
    }

    if ((a.value - b.value).abs() == 5) {
      return SOBRelShip.combination;
    }

    return SOBRelShip.none;
  }

  static Stems getStemsByComb(Stems stems) {
    return Stems.values.firstWhere((s) => (s.value % 10) == ((stems.value + 5) % 10));
  }

  static SOBCombOrConflict? getBothOfStemsCombOrConflict(StemsOrBranchElement a,
      StemsOrBranchElement b) {
    int smaller = min(a.value, b.value);
    int larger = max(a.value, b.value);

    if (larger - smaller == 5) {
      FivePhases phase = FivePhases.values
          .firstWhere((phase) => phase.value == (smaller % 5 + 1) % 5);
      return SOBCombOrConflict(
        label: phase.label,
        color: phase.color,
        value: SOBRelShip.combination.value,
      );
    }

    if (((a.value - b.value).abs() % 10 == 6)) {
      return SOBCombOrConflict(
        label: SOBRelShip.conflict.label!,
        color: const Color(0xffe5e5e5),
        value: SOBRelShip.conflict.value,
      );
    }

    return null;
  }

  static String complexRelation(Stems a, Stems b, [isShowControl = true]) {
    SOBCombination? combination = a + b;
    FivePhasesRelS relation = FivePhases.getBothOfInteraction(
        a.element, b.element);
    if ((relation == FivePhasesRelS.control ||
        relation == FivePhasesRelS.beControlled) && combination != null) {
      return combination.toString();
    } else if (isShowControl && (relation == FivePhasesRelS.control ||
        relation == FivePhasesRelS.beControlled)) {
      return a & b;
    } else {
      return '';
    }
  }
}

extension StemsOperations on Stems {
  // 定义合化关系表
  static final combinations = [
    const SOBCombination(Stems.jia, Stems.ji, FivePhases.earth), // 甲己合化土
    const SOBCombination(Stems.yi, Stems.geng, FivePhases.metal), // 乙庚合化金
    const SOBCombination(Stems.bing, Stems.xin, FivePhases.water), // 丙辛合化水
    const SOBCombination(Stems.ding, Stems.ren, FivePhases.wood), // 丁壬合化木
    const SOBCombination(Stems.wu, Stems.gui, FivePhases.fire) // 戊癸合化火
  ];

  // 定义相冲关系表
  static final conflicts = [
    const SOBConflict(Stems.jia, Stems.geng),
    const SOBConflict(Stems.yi, Stems.xin),
    const SOBConflict(Stems.bing, Stems.ren),
    const SOBConflict(Stems.ding, Stems.gui)
  ];

  /// 生同克
  String operator &(Stems other) {
    FivePhasesRelS rel = FivePhases.getBothOfInteraction(
        element, other.element);
    return switch (rel) {
      FivePhasesRelS.same => '$label${other.label}同',
      FivePhasesRelS.produce => '$label生${other.label}',
      FivePhasesRelS.beProduced => '${other.label}生$label',
      FivePhasesRelS.control => '$label克${other.label}',
      FivePhasesRelS.beControlled => '${other.label}克$label',
      _ => throw Exception('Invalid FivePhasesRelS: $rel')
    };
  }

  /// 合
  SOBCombination? operator +(Stems other) {
    for (var combination in combinations) {
      if ((this == combination.a && other == combination.b) ||
          (this == combination.b && other == combination.a)) {
        return combination;
      }
    }
    return null; // 不相合
  }

  /// 相冲
  SOBConflict? operator -(Stems other) {
    for (var conflict in conflicts) {
      if ((this == conflict.a && other == conflict.b) ||
          (this == conflict.b && other == conflict.a)) {
        return conflict;
      }
    }
    return null;
  }
}

/// 地支
enum Branches implements StemsOrBranchElement {
  zi(label: '子', element: FivePhases.water, value: 1),
  chou(label: '丑', element: FivePhases.earth, value: 2),
  yin(label: '寅', element: FivePhases.wood, value: 3),
  mao(label: '卯', element: FivePhases.wood, value: 4),
  chen(label: '辰', element: FivePhases.earth, value: 5),
  si(label: '巳', element: FivePhases.fire, value: 6),
  wu(label: '午', element: FivePhases.fire, value: 7),
  wei(label: '未', element: FivePhases.earth, value: 8),
  shen(label: '申', element: FivePhases.metal, value: 9),
  you(label: '酉', element: FivePhases.metal, value: 10),
  xu(label: '戌', element: FivePhases.earth, value: 11),
  hai(label: '亥', element: FivePhases.water, value: 12);

  @override
  final String label;
  @override
  final FivePhases element;
  @override
  final int value;

  const Branches(
      {required this.label, required this.element, required this.value});

  static Branches getBranchByValue(int value) {
    return Branches.values.firstWhere((branch) => value == branch.value);
  }

  static Branches getBranchByLabel(String value) {
    return Branches.values.firstWhere((branch) => value == branch.label);
  }

  static SOBRelShip getBothOfBranchRS(StemsOrBranchElement a,
      StemsOrBranchElement b) {
    if ((a.value - b.value).abs() == 6) {
      return SOBRelShip.conflict;
    }
    int smaller = min(a.value, b.value);
    if ((smaller > 2 && (a.value + b.value == 15)) || a.value + b.value == 3) {
      return SOBRelShip.combination;
    }

    return SOBRelShip.none;
  }

  static SOBCombOrConflict? getBothOfBranchCombOrConflict(
      StemsOrBranchElement a, StemsOrBranchElement b) {
    int smaller = min(a.value, b.value);

    if ((smaller > 2 && (a.value + b.value == 15)) || a.value + b.value == 3) {
      int value = 1;
      if (smaller == 1) {
        value = 2;
      } else if (smaller == 3) {
        value = 0;
      } else if (smaller == 4) {
        value = 1;
      } else if (smaller == 5) {
        value = 3;
      } else if (smaller == 6) {
        value = 4;
      } else if (smaller == 7) {
        value = 1;
      } else {
        throw 'Not Found';
      }
      FivePhases phase =
      FivePhases.values.firstWhere((phase) => phase.value == value);
      return SOBCombOrConflict(
        label: phase.label,
        color: phase.color,
        value: SOBRelShip.combination.value,
      );
    }

    if ((a.value - b.value).abs() == 6) {
      return SOBCombOrConflict(
        label: SOBRelShip.conflict.label!,
        color: const Color(0xffe5e5e5),
        value: SOBRelShip.conflict.value,
      );
    }

    return null;
  }

  static String complexRelation(Branches a, Branches b) {

    SOBCombination? combination = a + b;
    FivePhasesRelS relation = FivePhases.getBothOfInteraction(
        a.element, b.element);
    if ((relation == FivePhasesRelS.control ||
        relation == FivePhasesRelS.beControlled) && combination != null) {
      return combination.toString();
    } else if ((relation == FivePhasesRelS.control ||
        relation == FivePhasesRelS.beControlled)) {
      return a & b;
    } else {
      return '';
    }
  }
}

extension BranchesOperations on Branches {

  // 定义合化关系表
  static final combinations = [
    const SOBCombination(Branches.zi, Branches.chou, FivePhases.earth),
    // 子丑合化土
    const SOBCombination(Branches.yin, Branches.hai, FivePhases.wood),
    // 寅亥合化木
    const SOBCombination(Branches.mao, Branches.xu, FivePhases.fire),
    // 卯戌合化火
    const SOBCombination(Branches.chen, Branches.you, FivePhases.metal),
    // 辰酉合化金
    const SOBCombination(Branches.si, Branches.shen, FivePhases.water),
    // 巳申合化水
    const SOBCombination(Branches.wu, Branches.wei, FivePhases.fire)
    // 午未合化火
  ];


  // 定义相冲关系表
  static final conflicts = [
    const SOBConflict(Branches.zi, Branches.wu), // 子	午
    const SOBConflict(Branches.chou, Branches.wei), // 丑	未
    const SOBConflict(Branches.yin, Branches.shen), // 寅  申
    const SOBConflict(Branches.mao, Branches.you), // 卯	 酉
    const SOBConflict(Branches.chen, Branches.xu), // 辰  戌
    const SOBConflict(Branches.si, Branches.hai), // 巳	亥
  ];

  /// 生同克
  String operator &(Branches other) {
    FivePhasesRelS rel = FivePhases.getBothOfInteraction(
        element, other.element);
    return switch (rel) {
      FivePhasesRelS.same => '$label${other.label}同',
      FivePhasesRelS.produce => '$label生${other.label}',
      FivePhasesRelS.beProduced => '${other.label}生$label',
      FivePhasesRelS.control => '$label克${other.label}',
      FivePhasesRelS.beControlled => '${other.label}克$label',
      _ => throw Exception('Invalid FivePhasesRelS: $rel')
    };
  }

  /// 六合
  SOBCombination? operator +(Branches other) {
    for (var combination in combinations) {
      if ((this == combination.a && other == combination.b) ||
          (this == combination.b && other == combination.a)) {
        return combination;
      }
    }
    return null; // 不相合
  }

  /// 相冲
  SOBConflict? operator -(Branches other) {
    for (var conflict in conflicts) {
      if ((this == conflict.a && other == conflict.b) ||
          (this == conflict.b && other == conflict.a)) {
        return conflict;
      }
    }
    return null;
  }
}

/// 天干和地支方法
class StemsAndBranches {
  static List<StemsOrBranchElement> getStems() {
    return Stems.values.toList();
  }

  static StemsOrBranchElement getStemByValue(int value) {
    return Stems.values.firstWhere((element) => element.value == value);
  }

  static List<Stems> getStemsCyclicList(Stems item, int length) {
    List<Stems> list = Stems.values.toList();
    // 找到指定项的索引
    int startIndex = list.indexWhere((stems) => stems.value == item.value);

    return cyclicSort<Stems>(list, startIndex, length);
  }

  static List<StemsOrBranchElement> getBranches() {
    return Branches.values.toList();
  }

  static List<Branches> getBranchCyclicList(Branches item, int length) {
    List<Branches> list = Branches.values.toList();
    // 找到指定项的索引
    int startIndex = list.indexWhere((stems) => stems.value == item.value);

    return cyclicSort<Branches>(list, startIndex, length);
  }

  static StemsOrBranchElement getBranchByValue(int value) {
    return Branches.values.firstWhere((element) => element.value == value);
  }

  static StemsOrBranchElement getElementByLabel(String label) {
    if (Stems.values.any((element) => element.label == label)) {
      return Stems.values.firstWhere((element) => element.label == label);
    } else {
      return Branches.values.firstWhere((element) => element.label == label);
    }
  }

  static List<StemsBranchItem> getStemsByStemsBranchItem() {
    List<Stems> stemsList = Stems.values.toList();
    List<StemsBranchItem> items = [];
    for (int i = 0; i < stemsList.length; i++) {
      items.add(StemsBranchItem(stems: stemsList[i]));
    }
    return items;
  }

  static List<StemsBranchItem> getBranchesByStemsBranchItem() {
    List<Branches> branches = Branches.values.toList();
    List<StemsBranchItem> items = [];
    for (int i = 0; i < branches.length; i++) {
      items.add(StemsBranchItem(branch: branches[i]));
    }
    return items;
  }

  static List<StemsBranchItem> getMonthPillars(Stems stems) {
    List<Branches> branches = getBranchCyclicList(Branches.yin, 12);
    int value = (stems.value * 2 + 1) % 10;
    List<Stems> stemsList =
    getStemsCyclicList(Stems.getStemsByValue(value), 12);
    List<StemsBranchItem> items = [];
    for (int i = 0; i < 12; i++) {
      items.add(StemsBranchItem(stems: stemsList[i], branch: branches[i]));
    }
    return items;
  }

  static List<StemsBranchItem> getHourPillars(Stems stems) {
    List<Branches> branches = getBranchCyclicList(Branches.zi, 12);
    int value = (stems.value * 2 - 1) % 10;
    List<Stems> stemsList =
    getStemsCyclicList(Stems.getStemsByValue(value), 12);
    List<StemsBranchItem> items = [];
    for (int i = 0; i < 12; i++) {
      items.add(StemsBranchItem(stems: stemsList[i], branch: branches[i]));
    }
    return items;
  }
}

/// 六十甲子
class SixtyAZi {
  static List<StemsBranchItem> sixtyAZiList = List.generate(60, (index) {
    return AZiItemImpl(
      stems: Stems.values[index % 10],
      branch: Branches.values[index % 12],
    );
  });

  static List<StemsBranchItem?> getBranchesByStems(Stems stems) {
    List<Branches?> branches = sixtyAZiList
        .where((aziItem) => aziItem.stems == stems)
        .map((aziItem) => aziItem.branch)
        .toList();
    branches.sort((a, b) => a!.value.compareTo(b!.value));
    List<StemsBranchItem> items = [];
    for (int i = 0; i < branches.length; i++) {
      items.add(StemsBranchItem(branch: branches[i]));
    }
    return items;
  }

  List<StemsBranchItem> getSixtyAZiList() {
    return sixtyAZiList;
  }
}

class AZiItemImpl implements StemsBranchItem {
  @override
  final Stems stems;
  @override
  final Branches branch;

  const AZiItemImpl({required this.stems, required this.branch});

  @override
  String getNaYin() {
    return LunarUtil.NAYIN['${stems.label}${branch.label}']!;
  }

  @override
  String toString() {
    return '${stems.label}${branch.label}';
  }
}

Map<String, String> shiShenMap = {
  '正财': '财',
  '正官': '官',
  '正印': '印',
  '劫财': '劫',
  '伤官': '伤',
  '偏财': '才',
  '七杀': '杀',
  '偏印': '枭',
  '比肩': '比',
  '食神': '食',
};