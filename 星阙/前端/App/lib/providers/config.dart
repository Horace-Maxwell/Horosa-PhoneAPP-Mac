import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:horosa/constants/keys.dart';
import 'package:horosa/constants/liu_ren.dart';
import 'package:horosa/models/config.dart';
import 'package:horosa/models/qi_men.dart';
import 'package:horosa/utils/local_storage.dart';
import 'package:horosa/utils/log.dart';

LocalStorage _localStorage = LocalStorage();

class ConfigProvider extends ChangeNotifier {
  // 首页金刚区
  List<DockItem> docks = [];

  // 默认启用真太阳时
  bool useAST = false;

  // 是否显示八字干支关系线
  bool showBaZiSABLine = true;

  // 奇门遁甲定局
  QiMenType tuning = QiMenType.chaibu;

  // 六壬布局
  LayoutType layout = LayoutType.horizontal;

  void setDocks(List<DockItem> value) {
    docks = value;
    notifyListeners();
  }

  void setAST(bool value) {
    useAST = value;
    notifyListeners();
  }

  void setBaZiSABLine(bool value) {
    showBaZiSABLine = value;
    notifyListeners();
  }

  void setLayout(LayoutType value) {
    layout = value;
    notifyListeners();
  }

  void setTuning(QiMenType value) {
    tuning = value;
    notifyListeners();
  }

  ConfigProvider() {
    readConfig();
    Log.d('初始化配置完成');
  }

  /// 从本地读取配置
  Future<void> readConfig() async {
    _localStorage.read(AppKeys.config).then((value) {
      try {
        if(value != null) {
          Map<String, dynamic> json = jsonDecode(value);
          Config config = Config.fromJson(json);
          setDocks(config.docks);
          setAST(config.useAST);
          setBaZiSABLine(config.showBaZiSABLine);
          setLayout(config.layout);
          setTuning(config.tuning);
          notifyListeners();
        } else {
          Config config = const Config(
            docks: [],
            useAST: false,
            showBaZiSABLine: true,
            tuning: QiMenType.chaibu,
            layout: LayoutType.horizontal,
          );

          _localStorage.write(AppKeys.config, jsonEncode(config.toJson()));
        }
      } catch (e) {
        Log.d('读取配置失败');
        Log.d(e);
      }
    });
  }

  /// 保存配置
  Future<void> saveConfig() async {
    Config config = Config(
      docks: docks,
      useAST: useAST,
      showBaZiSABLine: showBaZiSABLine,
      tuning: tuning,
      layout: layout,
    );
    _localStorage.write(AppKeys.config, jsonEncode(config.toJson()));
  }

  Map<String, dynamic> toJson() => {
        'docks': List<dynamic>.from(docks.map((x) => x.toJson())),
        'useAST': useAST,
        'showBaZiSABLine': showBaZiSABLine,
        'tuning': tuning.value,
        'layout': layout.value,
      };
}
