import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/bazi.dart';
import 'package:lunar/lunar.dart';

/// 时间流
class TimeFlow extends StatefulWidget {
  const TimeFlow({super.key, required this.lunar});

  final Lunar lunar;

  @override
  State<TimeFlow> createState() => _TimeFlowState();
}

class _TimeFlowState extends State<TimeFlow> {
  late List<Solar> liuNian;
  late Solar selectedLiuNian;
  late List<Solar> liuYue;
  late Solar selectedLiuYue;
  late List<Solar> liuRi;
  late Solar selectedLiuRi;
  late String stemsAndBranch;
  late String datetime;
  late String solarTerm;

  List<Solar> generateLiuNian(Solar solar) {
    List<Solar> result = [];
    int startYear = solar.getYear() - 2;
    int endYear = solar.getYear() + 7;
    for (int i = startYear; i <= endYear; i++) {
      result.add(Solar.fromYmd(i, 6, 18));
    }
    return result;
  }

  List<Solar> generateLiuYue(Solar solar) {
    List<Solar> result = [];
    SolarYear solarYear = SolarYear.fromYear(solar.getYear());
    solarYear.getMonths().forEach((element) {

      result.add(Solar.fromYmd(element.getYear(), element.getMonth(), 1));
    });

    return result;
  }

  List<Solar> generateLiuRi(Solar solar) {
    SolarMonth solarMonth = SolarMonth.fromYm(solar.getYear(), solar.getMonth());
    return solarMonth.getDays();
  }


  initialize(solar) {
    liuNian = generateLiuNian(solar);
  }

  handler(solar) {
    selectedLiuNian = solar;
    liuYue = generateLiuYue(selectedLiuNian);
    selectedLiuYue = liuYue[0];
    liuRi = generateLiuRi(selectedLiuYue);
    selectedLiuRi = liuRi[0];
  }

  update() {
    Lunar currentLunar = Solar.fromYmd(selectedLiuNian.getYear(), selectedLiuYue.getMonth(), selectedLiuRi.getDay()).getLunar();
    String yearGanZhi = currentLunar.getYearInGanZhi();
    String monthGanZhi = currentLunar.getMonthInGanZhi();
    String dayGanZhi = currentLunar.getDayInGanZhi();
    stemsAndBranch = '$yearGanZhi年 $monthGanZhi月 $dayGanZhi日';
    JieQi jieQi = currentLunar.getNextJie(true);
    JieQi nextJieQi = currentLunar.getNextJie(true).getSolar().getLunar().getNextJie(true);
    Solar jieQiSolar = jieQi.getSolar();
    Solar nextJieQiSolar = nextJieQi.getSolar().prevHour(24);
    Lunar jieQiLunar = jieQiSolar.getLunar();
    Lunar nextJieQiLunar = nextJieQiSolar.getLunar();
    String jieQiDateStr = '${jieQiSolar.getMonth()}月${jieQiSolar.getDay()}日<${jieQiLunar.getMonthInChinese()}月${jieQiLunar.getDayInChinese()}>';
    String nextJieQiDateStr = '${nextJieQiSolar.getMonth()}月${nextJieQiSolar.getDay()}日<${nextJieQiLunar.getMonthInChinese()}月${nextJieQiLunar.getDayInChinese()}>';
    solarTerm = '${jieQi.getName()} $jieQiDateStr~$nextJieQiDateStr';
    datetime = '${selectedLiuNian.getYear()}年${selectedLiuYue.getMonth()}月${selectedLiuRi.getDay()}日（${currentLunar.getMonthInChinese()}月${currentLunar.getDayInChinese()}）';
  }

  @override
  void initState() {
    super.initState();
    Solar solar = widget.lunar.getSolar();
    initialize(solar);
    handler(solar);
    selectedLiuYue = solar;
    selectedLiuRi = solar;
    liuYue = generateLiuYue(solar);
    liuRi = generateLiuRi(selectedLiuYue);
    update();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.symmetric(horizontal: 36.w),
            children: [
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.r),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          '关闭',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 1.sw,
                        padding: EdgeInsets.only(top: 56.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '干支：$stemsAndBranch\n日期：$datetime\n节令：$solarTerm',
                              style: TextStyle(
                                color: const Color(0xff393b41),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 48.w),
                            // 流年
                            Container(
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1.w, color: const Color(0x2de5e5e5)),
                                  borderRadius: BorderRadius.circular(36.r),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: const Color(0x13222327),
                                    blurRadius: 12.r,
                                    offset: Offset(0, 8.w),
                                    spreadRadius: -4.r,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 36.w,
                                      child: Text(
                                        '流\n年',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xff222426),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: SizedBox(
                                        height: 156.w,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal, // 设置为横向滚动
                                          itemCount: liuNian.length, // 列表项数量
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedLiuNian = liuNian[index];
                                                  handler(selectedLiuNian);
                                                  update();
                                                });
                                              },
                                              child: SizedBox(
                                                width: 64.w,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Visibility(
                                                      visible: liuNian[index].getYear() == selectedLiuNian.getYear(),
                                                      child: Positioned.fill(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius.circular(16.r),
                                                          child: Container(
                                                            color: const Color(0xfff2f2f2),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: liuNian[index].getYear() == selectedLiuNian.getYear(),
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          width: 60.w,
                                                          height: 10.w,
                                                          decoration: ShapeDecoration(
                                                            color: const Color(0xff222426),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(16.r),
                                                                topRight: Radius.circular(16.r),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                      EdgeInsets.symmetric(vertical: 24.w),
                                                      width: 1.sw,
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: const Color(0xffe5e5e5),
                                                              width: 2.w,
                                                            ),
                                                          )),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            '${liuNian[index].getYear()}',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xff8d8d8d),
                                                              fontSize: 20.sp,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5.w),
                                                          SizedBox(
                                                            width: 25.w,
                                                            child: Text(
                                                              liuNian[index].getLunar().getYearInGanZhi(),
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: const Color(0xff222426),
                                                                fontSize: 24.sp,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20.w),

                            /// 流月
                            Container(
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1.w, color: const Color(0x2de5e5e5)),
                                  borderRadius: BorderRadius.circular(36.r),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: const Color(0x13222327),
                                    blurRadius: 12.r,
                                    offset: Offset(0, 8.w),
                                    spreadRadius: -4.r,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 36.w,
                                      child: Text(
                                        '流\n月',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xff222426),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: SizedBox(
                                        height: 186.w,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal, // 设置为横向滚动
                                          itemCount: liuYue.length, // 列表项数量
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedLiuYue = liuYue[index];
                                                  liuRi = generateLiuRi(selectedLiuYue);
                                                  selectedLiuRi = liuRi[0];
                                                  update();
                                                });
                                              },
                                              child: SizedBox(
                                                width: 64.w,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Visibility(
                                                      visible: liuYue[index].getMonth() == selectedLiuYue.getMonth(),
                                                      child: Positioned.fill(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius.circular(16.r),
                                                          child: Container(
                                                            color: const Color(0xfff2f2f2),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: liuYue[index].getMonth() == selectedLiuYue.getMonth(),
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          width: 60.w,
                                                          height: 10.w,
                                                          decoration: ShapeDecoration(
                                                            color: const Color(0xff222426),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(16.r),
                                                                topRight: Radius.circular(16.r),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                      EdgeInsets.symmetric(vertical: 24.w),
                                                      width: 1.sw,
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: const Color(0xffe5e5e5),
                                                              width: 2.w,
                                                            ),
                                                          )),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            liuYue[index].getLunar().getNextJie(true).getName(),
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xff8d8d8d),
                                                              fontSize: 20.sp,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          SizedBox(height: 4.w),
                                                          Text(
                                                            '${liuYue[index].getLunar().getNextJie(true).getSolar().getMonth()}/${liuYue[index].getLunar().getNextJie(true).getSolar().getDay()}',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xff8d8d8d),
                                                              fontSize: 18.sp,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          SizedBox(height: 10.w),
                                                          SizedBox(
                                                            width: 25.w,
                                                            child: Text(
                                                              liuYue[index].getLunar().getNextJie(true).getSolar().getLunar().getMonthInGanZhi(),
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: const Color(0xff222426),
                                                                fontSize: 24.sp,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20.w),

                            /// 流日
                            Container(
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36.r),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: const Color(0x13222327),
                                    blurRadius: 12.r,
                                    offset: Offset(0, 8.w),
                                    spreadRadius: -4.r,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 36.w,
                                      child: Text(
                                        '流\n日',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xff222426),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: SizedBox(
                                        height: 156.w,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal, // 设置为横向滚动
                                          itemCount: liuRi.length, // 列表项数量
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedLiuRi = liuRi[index];
                                                  update();
                                                });
                                              },
                                              child: SizedBox(
                                                width: 64.w,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Visibility(
                                                      visible: liuRi[index].toString() == selectedLiuRi.toString(),
                                                      child: Positioned.fill(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                          BorderRadius.circular(16.r),
                                                          child: Container(
                                                            color: const Color(0xfff2f2f2),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: liuRi[index].toString() == selectedLiuRi.toString(),
                                                      child: Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          width: 60.w,
                                                          height: 10.w,
                                                          decoration: ShapeDecoration(
                                                            color: const Color(0xff222426),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(16.r),
                                                                topRight: Radius.circular(16.r),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                      EdgeInsets.symmetric(vertical: 24.w),
                                                      width: 1.sw,
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: const Color(0xffe5e5e5),
                                                              width: 2.w,
                                                            ),
                                                          )),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            '${liuRi[index].getMonth()}/${liuRi[index].getDay()}',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xff8d8d8d),
                                                              fontSize: 20.sp,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5.w),
                                                          SizedBox(
                                                            width: 25.w,
                                                            child: Text(
                                                              liuRi[index].getLunar().getDayInGanZhi(),
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: const Color(0xff222426),
                                                                fontSize: 24.sp,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
    );
  }
}
