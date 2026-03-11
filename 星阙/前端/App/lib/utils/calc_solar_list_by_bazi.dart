import 'package:lunar/lunar.dart';

List<Solar> calcSolarListByBaZi(
    String yearGanZhi, String monthGanZhi, String dayGanZhi, String timeGanZhi,
    {int sect = 2, int baseYear = 1500}) {
  sect = (1 == sect) ? 1 : 2;
  List<Solar> l = [];
  // 月地支距寅月的偏移值
  int m = LunarUtil.find(monthGanZhi.substring(1), LunarUtil.ZHI, -1) - 2;
  if (m < 0) {
    m += 12;
  }
  // 月天干要一致
  if (((LunarUtil.find(yearGanZhi.substring(0, 1), LunarUtil.GAN, -1) + 1) * 2 +
              m) %
          10 !=
      LunarUtil.find(monthGanZhi.substring(0, 1), LunarUtil.GAN, -1)) {
    return l;
  }
  // 1年的立春是辛酉，序号57
  int y = LunarUtil.getJiaZiIndex(yearGanZhi) - 57;
  if (y < 0) {
    y += 60;
  }
  y++;
  // 节令偏移值
  m *= 2;
  // 时辰地支转时刻，子时按零点算
  int h = LunarUtil.find(timeGanZhi.substring(1), LunarUtil.ZHI, -1) * 2;
  List<int> hours = [h];
  if (0 == h && 2 == sect) {
    hours.add(23);
  }
  int startYear = baseYear - 1;

  // 结束年
  int endYear = 2099;

  while (y <= endYear) {
    if (y >= startYear) {
      // 立春为寅月的开始
      // 节令推移，年干支和月干支就都匹配上了
      Solar solarTime =
          Lunar.fromYmd(y, 1, 1).getJieQiTable()[Lunar.JIE_QI_IN_USE[4 + m]]!;
      if (solarTime.getYear() >= baseYear) {
        // 日干支和节令干支的偏移值
        int d = LunarUtil.getJiaZiIndex(dayGanZhi) -
            LunarUtil.getJiaZiIndex(
                solarTime.getLunar().getDayInGanZhiExact2());
        if (d < 0) {
          d += 60;
        }
        if (d > 0) {
          // 从节令推移天数
          solarTime = solarTime.next(d);
        }
        for (int hour in hours) {
          int mi = 0;
          int s = 0;
          if (d == 0 && hour == solarTime.getHour()) {
            // 如果正好是节令当天，且小时和节令的小时数相等的极端情况，把分钟和秒钟带上
            mi = solarTime.getMinute();
            s = solarTime.getSecond();
          }
          // 验证一下
          Solar solar = Solar.fromYmdHms(solarTime.getYear(),
              solarTime.getMonth(), solarTime.getDay(), hour, mi, s);
          Lunar lunar = solar.getLunar();
          String dgz = (2 == sect)
              ? lunar.getDayInGanZhiExact2()
              : lunar.getDayInGanZhiExact();
          if (lunar.getYearInGanZhiExact() == yearGanZhi &&
              lunar.getMonthInGanZhiExact() == monthGanZhi &&
              dgz == dayGanZhi &&
              lunar.getTimeInGanZhi() == timeGanZhi) {
            l.add(solar);
          }
        }
      }
    }
    y += 60;
  }
  return l;
}
