import 'package:lunar/lunar.dart';

enum CalendarType {
  solar,
  lunar,
  pillars
}

class Calendar {
  final CalendarType type;
  final Solar value;

  const Calendar({ required this.type, required this.value });

  String getSolarToStr({ bool withChinese = false }) {
    int year = value.getYear();
    String month = value.getMonth().toString().padLeft(2, '0');
    String day = value.getDay().toString().padLeft(2, '0');
    String hour = value.getHour().toString().padLeft(2, '0');
    String minute = value.getMinute().toString().padLeft(2, '0');
    if(withChinese) {
      return '$year年$month月$day日 $hour时$minute分';
    }
    return '$year-$month-$day $hour:$minute';
  }

  String getLunarToStr() {
    Lunar lunar = value.getLunar();
    String year = lunar.getYearInChinese();
    String month = lunar.getMonthInChinese();
    String day = lunar.getDayInChinese();
    String hour = lunar.getHour().toString().padLeft(2, '0');
    String minute = lunar.getMinute().toString().padLeft(2, '0');
    return '$year年$month月$day $hour:$minute';
  }

  String getPillarsToStr() {
    Lunar lunar = value.getLunar();
    EightChar e = lunar.getEightChar();
    e.setSect(1);
    String year = e.getYearGan() + e.getYearZhi();
    String month = e.getMonthGan() + e.getMonthZhi();
    String day = e.getDayGan() + e.getDayZhi();
    String hour = e.getTimeGan() + e.getTimeZhi();
    return '$year年 $month月 $day日 $hour时';
  }

  @override
  String toString() {
    if(CalendarType.pillars == type) {
      return getPillarsToStr();
    } else if(CalendarType.lunar == type) {
      return getLunarToStr();
    } else {
      return getSolarToStr();
    }
  }
}