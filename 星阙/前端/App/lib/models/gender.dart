// 性别 enum
enum Gender {
  male(label: '男', value: 1, alias: '男命', aliasValue: 1),
  female(label: '女', value: 0, alias: '女命', aliasValue: 2),;

  final String label;
  final int value;
  final String alias;
  final int aliasValue;

  const Gender({ required this.label, required this.value, required this.alias, required this.aliasValue });

  static Gender getByAliasValue(int value) {
    return Gender.values.firstWhere((element) => element.aliasValue == value);
  }

  static Gender? getByValue(int? value) {
    if(value == null) {
      return null;
    }
    return Gender.values.firstWhere((element) => element.value == value);
  }
}