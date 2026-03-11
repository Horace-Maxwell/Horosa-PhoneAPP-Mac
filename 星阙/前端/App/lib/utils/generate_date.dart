import 'package:lunar/lunar.dart';

List<String> generateYears() {
  List<String> years = [];
  for (int i = 0; i < 100; i++) {
    years.add('$i'.padLeft(2, '0'));
  }

  return years;
}

List<int> generateSolarMonths(int year) {
  List<int> months = [];
  for (int i = 1; i < 13; i++) {
    months.add(i);
  }

  return months;
}

List<int> generateLunarMonths(int year) {
  LunarYear lunarYear = LunarYear.fromYear(year);
  List<LunarMonth> lunarMonths = lunarYear.getMonthsInYear();
  List<int> months = [];
  for (int i = 0; i <= lunarMonths.length - 1; i++) {
    months.add(lunarMonths[i].getMonth());
  }

  return months;
}

List<int> generateSolarDays(int year, int month) {
  SolarMonth? solarMonth = SolarMonth.fromYm(year, month);
  List<int> days = [];

  solarMonth.getDays().forEach((day) => days.add(day.getDay()));

  return days;
}

List<int> generateLunarDays(int year, int month) {
  LunarMonth? lunarMonth = LunarMonth.fromYm(year, month);
  List<int> days = [];

  if (lunarMonth != null) {
    days = List.generate(lunarMonth.getDayCount(), (i) => i + 1);
  }
  return days;
}

List<int> generateHours() {
  List<int> hours = [];
  for (int i = 0; i < 24; i++) {
    hours.add(i);
  }

  return hours;
}

List<int> generateMinutes() {
  List<int> minutes = [];
  for (int i = 0; i < 60; i++) {
    minutes.add(i);
  }

  return minutes;
}