import 'package:flutter/widgets.dart';
import 'package:horosa/utils/toast.dart';

class DateTimeStrParser {
  // 判断是否为闰年
  bool isLeapYear(int cc, int yy) {
    int year = cc * 100 + yy;
    // 闰年规则：年份能被4整除且不能被100整除，或者能被400整除
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  // 提取并转换字符串的函数
  List<int> parseDateTimeString(String datetime) {
    try {
      int cc = int.parse(datetime.substring(0, 2));
      int yy = int.parse(datetime.substring(2, 4));
      int mm = int.parse(datetime.substring(4, 6));
      int dd = int.parse(datetime.substring(6, 8));
      int hh = int.parse(datetime.substring(8, 10));
      int min = int.parse(datetime.substring(10, 12));
      return [cc, yy, mm, dd, hh, min];
    } catch (e) {
      return [];
    }
  }

  // 主方法：拆分字符串并校验
  bool validateAndSplit(String datetime, {required BuildContext context}) {
    if (datetime.length != 12) {
      toast('时间长度应为 12', context: context);
      return false;
    }

    // 使用 parseDateTimeString 函数获取日期时间组件
    List<int> dateTimeComponents = parseDateTimeString(datetime);
    int ccValue = dateTimeComponents[0];
    int yyValue = dateTimeComponents[1];
    int mmValue = dateTimeComponents[2];
    int ddValue = dateTimeComponents[3];
    int hhValue = dateTimeComponents[4];
    int minValue = dateTimeComponents[5];

    // 校验 CC
    if (ccValue < 15 || ccValue > 20) {
      toast('年份范围仅支持 1500~2099', context: context);
      return false;
    }

    // 校验 YY
    if (yyValue < 0 || yyValue > 99) {
      toast('年份范围仅支持 1500~2099', context: context);
      return false;
    }

    // 校验 MM
    if (mmValue < 1 || mmValue > 12) {
      toast('月份有误', context: context);
      return false;
    }

    // 校验 DD，根据 MM 处理特殊情况
    if (ccValue == 15 && yyValue == 82 && mmValue == 10) {
      if (!((ddValue >= 1 && ddValue <= 4) ||
          (ddValue >= 15 && ddValue <= 31))) {
        toast('$mmValue 月不存在该天', context: context);
        return false;
      }
    } else {
      // 通常情况下校验 DD
      List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

      // 如果MM为2（2月），则需要判断闰年情况
      if (mmValue == 2 && isLeapYear(ccValue, yyValue)) {
        daysInMonth[1] = 29; // 闰年2月有29天
      }

      if (ddValue < 1 || ddValue > daysInMonth[mmValue - 1]) {
        toast('$mmValue 月不存在该天', context: context);
        return false;
      }
    }

    // 校验 hh
    if (hhValue < 0 || hhValue > 23) {
      toast('时分有误', context: context);
      return false;
    }

    // 校验 mm 和 ss
    if (minValue < 0 || minValue > 59) {
      toast('时分有误', context: context);
      return false;
    }

    // 如果所有校验都通过
    return true;
  }
}
