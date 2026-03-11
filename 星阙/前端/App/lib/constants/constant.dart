Map<String, String> relationAssets = {
  '天干寄宫': 'assets/images/ji-gong.png',
  '三合': 'assets/images/san-he.png',
  '刑': 'assets/images/xing.png',
  '破': 'assets/images/po.png',
  '害': 'assets/images/hai.png',
  '六合': 'assets/images/liu-he.png',
};

Map<String, String> get relationAssetsMap => relationAssets;

class FivePhasesGrowthItem {
  final String label;
  final String value;
  final String src;
  const FivePhasesGrowthItem({ required this.label, required this.value, required this.src });
}

List<FivePhasesGrowthItem> fivePhasesGrowthList = [
  const FivePhasesGrowthItem(label: '木-甲乙寅卯', value: '木-甲乙寅卯', src: 'assets/images/wood.png'),
  const FivePhasesGrowthItem(label: '火-丙丁巳午', value: '火-丙丁巳午', src: 'assets/images/fire.png'),
  const FivePhasesGrowthItem(label: '金-庚辛申酉', value: '金-庚辛申酉', src: 'assets/images/metal.png'),
  const FivePhasesGrowthItem(label: '水-壬癸亥子', value: '水-壬癸亥子', src: 'assets/images/water-earth.png'),
  const FivePhasesGrowthItem(label: '土-戊己辰戌丑末', value: '土-戊己辰戌丑末', src: 'assets/images/water-earth.png'),
];

/// 地支三合关系表
Map<String, String> threeCombinations = {
  '寅午': '寅午半合火局',
  '午寅': '午寅半合火局',
  '午戌': '午戌半合火局',
  '戌午': '戌午半合火局',
  '寅戌': '寅戌拱合火局',
  '戌寅': '寅戌拱合火局',
  '寅午戌': '寅午戌三合火局',
  '寅戌午': '寅午戌三合火局',
  '午戌寅': '寅午戌三合火局',
  '午寅戌': '寅午戌三合火局',
  '戌寅午': '寅午戌三合火局',
  '戌午寅': '寅午戌三合火局',

  '巳酉': '巳午半合金局',
  '酉巳': '午巳半合金局',
  '酉丑': '酉丑半合金局',
  '丑酉': '酉丑半合金局',
  '巳丑': '巳丑拱合金局',
  '丑巳': '巳丑拱合金局',
  '巳酉丑': '巳酉丑三合金局',
  '巳丑酉': '巳酉丑三合金局',
  '酉丑巳': '巳酉丑三合金局',
  '酉巳丑': '巳酉丑三合金局',
  '丑巳酉': '巳酉丑三合金局',
  '丑酉巳': '巳酉丑三合金局',

  '亥卯': '亥卯半合木局',
  '卯亥': '亥卯半合木局',
  '卯未': '卯未半合木局',
  '未卯': '卯未半合木局',
  '亥未': '亥未拱合木局',
  '未亥': '亥未拱合木局',
  '亥卯未': '亥卯未三合木局',
  '亥未卯': '亥卯未三合木局',
  '卯未亥': '亥卯未三合木局',
  '卯亥未': '亥卯未三合木局',
  '未亥卯': '亥卯未三合木局',
  '未卯亥': '亥卯未三合木局',

  '申子': '申子半合水局',
  '子申': '申子半合水局',
  '子辰': '子辰半合水局',
  '辰子': '子辰半合水局',
  '申辰': '申辰拱合水局',
  '辰申': '申辰拱合水局',
  '申子辰': '申子辰三合水局',
  '申辰子': '申子辰三合水局',
  '子辰申': '申子辰三合水局',
  '子申辰': '申子辰三合水局',
  '辰申子': '申子辰三合水局',
  '辰子申': '申子辰三合水局',
};

Map<String, String> get threeCombinationsMap => threeCombinations;

/// 地支三会关系表
Map<String, String> threeMeetings = {
  '寅辰': '寅辰拱会东方木局',
  '辰寅': '寅辰拱会东方木局',
  '寅卯辰': '寅卯辰三会东方木局',
  '寅辰卯': '寅卯辰三会东方木局',
  '卯辰寅': '寅卯辰三会东方木局',
  '卯寅辰': '寅卯辰三会东方木局',
  '辰寅卯': '寅卯辰三会东方木局',
  '辰卯寅': '寅卯辰三会东方木局',

  '巳未': '巳未拱会南方火局',
  '未巳': '巳未拱会南方火局',
  '巳午未': '巳午未三会南方火局',
  '巳未午': '巳午未三会南方火局',
  '午未巳': '巳午未三会南方火局',
  '午巳未': '巳午未三会南方火局',
  '未午巳': '巳午未三会南方火局',
  '未巳午': '巳午未三会南方火局',

  '申戌': '申戌拱会西方金局',
  '戌申': '申戌拱会西方金局',
  '申酉戌': '申酉戌三会西方金局',
  '申戌酉': '申酉戌三会西方金局',
  '酉戌申': '申酉戌三会西方金局',
  '酉申戌': '申酉戌三会西方金局',
  '戌酉申': '申酉戌三会西方金局',
  '戌申酉': '申酉戌三会西方金局',

  '亥丑': '亥丑拱会北方水局',
  '丑亥': '亥丑拱会北方水局',
  '亥子丑': '亥子丑三会北方水局',
  '亥丑子': '亥子丑三会北方水局',
  '子丑亥': '亥子丑三会北方水局',
  '子亥丑': '亥子丑三会北方水局',
  '丑亥子': '亥子丑三会北方水局',
  '丑子亥': '亥子丑三会北方水局',
};

Map<String, String> get threeMeetingsMap => threeMeetings;

/// 地支暗合
Map<String, String> secretCombinations = {
  '寅午': '寅午暗合',
  '午寅': '午寅暗合',
  '卯申': '卯申暗合',
  '申卯': '卯申暗合',
  '巳酉': '巳酉暗合',
  '酉巳': '酉巳暗合',
  '亥午': '亥午暗合',
  '午亥': '午亥暗合',
  '子巳': '子巳暗合',
  '巳子': '子巳暗合',
};

Map<String, String> get secretCombinationsMap => secretCombinations;

/// 地支暗会 子巳、午亥、卯申、寅酉、未辰、辰丑
Map<String, String> secretMeetings = {
  '子巳': '子巳暗会',
  '巳子': '子巳暗会',
  '午亥': '午亥暗会',
  '亥午': '午亥暗会',
  '卯申': '卯申暗会',
  '申卯': '卯申暗会',
  '寅酉': '寅酉暗会',
  '酉寅': '寅酉暗会',
  '辰丑': '辰丑暗会',
  '丑辰': '辰丑暗会',
};

Map<String, String> get secretMeetingsMap => secretMeetings;

/// 地支相刑
// 子	卯
// 寅	巳
// 巳	申
// 申	寅
// 未	戌
// 戌	丑
// 丑	未
// 辰	辰
// 午	午
// 酉	酉
// 亥	亥
Map<String, String> punishments = {
  '子卯': '子卯相刑',
  '卯子': '子卯相刑',
  '寅巳': '寅巳相刑',
  '巳寅': '寅巳相刑',
  '申寅': '申寅相刑',
  '寅申': '申寅相刑',
  '巳酉': '巳酉相刑',
  '酉巳': '巳酉相刑',
  '未戌': '未戌相刑',
  '戌未': '未戌相刑',
  '丑未': '丑未相刑',
  '未丑': '丑未相刑',
  '辰辰': '辰辰相刑',
  '午午': '午午相刑',
  '酉酉': '酉酉相刑',
  '亥亥': '亥亥相刑',
};

Map<String, String> get punishmentsMap => punishments;

/// 地支相害
// 子	未
// 丑	午
// 寅	巳
// 卯	辰
// 申	亥
// 酉	戌
Map<String, String> harms = {
  '子未': '子未相害',
  '未子': '子未相害',
  '丑午': '丑午相害',
  '午丑': '丑午相害',
  '寅巳': '寅巳相害',
  '巳寅': '寅巳相害',
  '卯辰': '卯辰相害',
  '辰卯': '卯辰相害',
  '申亥': '申亥相害',
  '亥申': '申亥相害',
  '酉戌': '酉戌相害',
  '戌酉': '酉戌相害',
};

Map <String, String> get harmsMap => harms;

/// 地支相破
// 子	酉
// 午	卯
// 辰	丑
// 未	戌
// 寅	亥
// 申	巳
 Map<String, String> destruction = {
   '子酉': '子酉相破',
   '酉子': '子酉相破',
   '午卯': '午卯相破',
   '卯午': '午卯相破',
   '辰丑': '辰丑相破',
   '丑辰': '辰丑相破',
   '未戌': '未戌相破',
   '戌未': '未戌相破',
   '寅亥': '寅亥相破',
   '亥寅': '寅亥相破',
   '申巳': '申巳相破',
   '巳申': '申巳相破',
 };

 Map<String, String> get destructionMap => destruction;