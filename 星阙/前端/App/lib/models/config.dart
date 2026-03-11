import 'qi_men.dart';
import '../constants/liu_ren.dart';

class DockItem {
  final String name;
  final int sort;
  final String ident;
  final int status;
  final String logo;

  const DockItem({
    required this.name,
    required this.sort,
    required this.ident,
    required this.status,
    required this.logo,
  });

  factory DockItem.fromJson(Map<String, dynamic> json) {
    return DockItem(
      name: json['name'],
      sort: json['sort'],
      ident: json['ident'],
      status: json['status'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'sort': sort,
    'ident': ident,
    'status': status,
    'logo': logo,
  };
}

class Config {
  // 首页金刚区
  final List<DockItem> docks;
  // 默认启用真太阳时
  final bool useAST;
  // 是否显示八字干支关系线
  final bool showBaZiSABLine;
  // 奇门遁甲定局
  final QiMenType tuning;
  // 六壬布局
  final LayoutType layout;

  const Config({
    required this.docks,
    required this.useAST,
    required this.showBaZiSABLine,
    required this.tuning,
    required this.layout,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      docks: List<DockItem>.from(json['docks'].map((x) => DockItem.fromJson(x))),
      useAST: json['useAST'],
      showBaZiSABLine: json['showBaZiSABLine'],
      tuning: QiMenType.values.firstWhere((e) => e.value == json['tuning']),
      layout: LayoutType.values.firstWhere((e) => e.value == json['layout']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docks': List<dynamic>.from(docks.map((x) => x.toJson())),
      'useAST': useAST,
      'showBaZiSABLine': showBaZiSABLine,
      'tuning': tuning.value,
      'layout': layout.value,
    };
  }

  @override
  String toString() {
    return 'Config(useAST: $useAST, showBaZiSABLine: $showBaZiSABLine, tuning: $tuning, layout: $layout, docks: $docks)';
  }
}