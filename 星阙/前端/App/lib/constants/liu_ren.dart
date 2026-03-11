enum LayoutType {
  // 三宫布局
  grid(label: '三宫布局', value: 1),
  // 横排布局
  horizontal(label: '横排布局', value: 2),;

  final int value;
  final String label;
  const LayoutType({ required this.label, required this.value });
}

List<LayoutType> get layoutTypes => [LayoutType.grid, LayoutType.horizontal];

Map<String, String> timeBranch2StemsMap = {
  '子': '甲',
  '丑': '乙',
  '寅': '丙',
  '卯': '丁',
  '辰': '戊',
  '巳': '己',
  '午': '庚',
  '未': '辛',
  '申': '壬',
  '酉': '癸',
  '戌': '甲',
  '亥': '乙',
};