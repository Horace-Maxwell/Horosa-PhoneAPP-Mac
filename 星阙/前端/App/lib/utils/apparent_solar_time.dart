import 'dart:math';
import 'package:intl/intl.dart';

class ApparentSolarTime {
  final double longitude; // 观测地点的经度
  final double timeZoneOffset; // 时区偏移

  ApparentSolarTime(this.longitude, this.timeZoneOffset);

  DateTime calculate(DateTime dateTime) {
    // 1. 转换为UTC时间
    DateTime utcTime = dateTime.toUtc();

    // 2. 计算经度时间修正（LTC）
    double standardLongitude = timeZoneOffset * 15.0;
    double ltc = (longitude - standardLongitude) * 4.0 * 60.0; // 以秒为单位

    // 3. 计算时间方程（EoT）
    int dayOfYear = _dayOfYear(utcTime);
    double eot = _equationOfTime(dayOfYear);

    // 4. 综合计算真太阳时
    double totalCorrection = ltc + eot * 60.0; // 以秒为单位
    DateTime apparentSolarTime = utcTime.add(Duration(seconds: totalCorrection.round()));

    // 将真太阳时转换回本地时间
    DateTime apparentSolarLocalTime = apparentSolarTime.add(Duration(hours: timeZoneOffset.toInt()));

    return apparentSolarLocalTime;
  }

  int _dayOfYear(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return dayOfYear;
  }

  double _equationOfTime(int dayOfYear) {
    double B = (360.0 / 365.0) * (dayOfYear - 81) * (pi / 180.0);
    double eot = 9.87 * sin(2 * B) - 7.53 * cos(B) - 1.5 * sin(B);
    return eot;
  }
}

// void main() {
//   // 北京时间2024年8月1日00:00:00
//   DateTime dateTime = DateTime(2024, 8, 1, 0, 0, 0);
//   double longitude = 116.4074; // 北京经度
//   int timeZoneOffset = 8; // 北京时区偏移量
//
//   ApparentSolarTime astCalculator = ApparentSolarTime(longitude, timeZoneOffset);
//   DateTime ast = astCalculator.calculate(dateTime);
//
//   print("标准时间: $dateTime");
//   print("真太阳时: $ast");
// }
