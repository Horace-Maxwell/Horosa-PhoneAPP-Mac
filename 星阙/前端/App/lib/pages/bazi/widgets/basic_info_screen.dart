import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/models/bazi.dart';
import 'package:horosa/models/horosa.dart';
import 'package:horosa/utils/utils.dart';
import 'package:lunar/lunar.dart';

class BasicInfoScreen extends StatelessWidget {
  const BasicInfoScreen({super.key, required this.form});

  final BaZiInput form;

  String genderToStr() {
    return form.gender.value == 1 ? '（乾造）' : '（坤造）';
  }

  String ageToStr() {
    int currentYear = DateTime.now().year;
    int age = currentYear - form.birthday.getYear();
    return age < 0 ? '0岁' : '$age岁';
  }

  String _calculateAST(Solar? birth, double? longitude, int gmtOffset) {
    if (birth == null || longitude == null) {
      return '';
    }
    int year = birth.getYear();
    int month = birth.getMonth();
    int day = birth.getDay();
    int hour = birth.getHour();
    int minute = birth.getMinute();
    int second = birth.getSecond();
    DateTime dateTime = DateTime(year, month, day, hour, minute, second);
    double timeZoneOffset = gmtOffset / 3600; // 北京时区偏移量

    ApparentSolarTime astCalculator =
    ApparentSolarTime(longitude, timeZoneOffset);
    DateTime ast = astCalculator.calculate(dateTime);
    int astYear = ast.year;
    String astMonth = ast.month.toString().padLeft(2, '0');
    String astDay = ast.day.toString().padLeft(2, '0');
    String astHour = ast.hour.toString().padLeft(2, '0');
    String astMinute = ast.minute.toString().padLeft(2, '0');
    return '$astYear-$astMonth-$astDay $astHour:$astMinute';
  }

  @override
  Widget build(BuildContext context) {
    BaZi bazi = BaZi(form.birthday.getLunar());
    EightChar e = bazi.getEightChar();
    e.setSect(1);

    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(left: 36.w, top: 30.w, right: 36.w, bottom: 30.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 30.w),
              decoration: ShapeDecoration(
                color: const Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x13222327),
                    blurRadius: 12,
                    offset: Offset(0, 8),
                    spreadRadius: -4,
                  )
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: ShapeDecoration(
                          color: const Color(0xff222426),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/logo.svg',
                            width: 64.w,
                            height: 64.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 18.w),
                      Text(
                        ageToStr(),
                        style: TextStyle(
                          color: const Color(0xff8d8d8d),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 30.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${form.username.isNotEmpty ? form.username : '无名氏'}${genderToStr()}',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.w,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                            child: Text(
                              e.getYearGan() + e.getYearZhi(),
                              style: TextStyle(
                                color: const Color(0xff222426),
                                fontSize: 24.sp,
                                height: 1.65,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 36.w),
                          SizedBox(
                            width: 24.w,
                            child: Text(
                              e.getMonthGan() + e.getMonthZhi(),
                              style: TextStyle(
                                color: const Color(0xff222426),
                                fontSize: 24.sp,
                                height: 1.65,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 36.w),
                          SizedBox(
                            width: 24.w,
                            child: Text(
                              e.getDayGan() + e.getDayZhi(),
                              style: TextStyle(
                                color: const Color(0xff222426),
                                fontSize: 24.sp,
                                height: 1.65,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 36.w),
                          SizedBox(
                            width: 24.w,
                            child: Text(
                              e.getTimeGan() + e.getTimeZhi(),
                              style: TextStyle(
                                color: const Color(0xff222426),
                                fontSize: 24.sp,
                                height: 1.65,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Container(
              decoration: ShapeDecoration(
                color: const Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x13222327),
                    blurRadius: 12,
                    offset: Offset(0, 8),
                    spreadRadius: -4,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:'农历：',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: bazi.getLunarToStr(),
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]
                          )
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:'性别：',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: form.gender.label,
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]
                          )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    color: const Color(0xfff9f9f9),
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                      vertical: 20.w,
                    ),
                    child: Text(
                      '北京时间：${bazi.getSolarToStr()}',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '真太阳时：${!form.useAST ? bazi.getSolarToStr() : _calculateAST(bazi.getSolar(), form.birthplace.longitude, form.birthplace.gmtOffset)}',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:'属相：',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: bazi.getYearShengXiao(),
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]
                          )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    color: const Color(0xfff9f9f9),
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                      vertical: 20.w,
                    ),
                    child: Text(
                      '出生地点：${form.birthplace.toString()}',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Container(
                  //   width: 1.sw,
                  //   color: const Color(0xffffffff),
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 36.w,
                  //     vertical: 20.w,
                  //   ),
                  //   child: Text(
                  //     '人元司令分野：癸水用事',
                  //     style: TextStyle(
                  //       color: const Color(0xff222426),
                  //       fontSize: 30.sp,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    width: 1.sw,
                    color: const Color(0xfff9f9f9),
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                      vertical: 20.w,
                    ),
                    child: Text(
                      '出生节气：出生于${bazi.getPrevJieQi(true)}后${bazi.getSolar().subtractMinute(bazi.getPrevJieQi(true).getSolar()) ~/ 1440}天${(bazi.getSolar().subtractMinute(bazi.getPrevJieQi(true).getSolar()) % 1440) ~/ 60}小时，${bazi.getNextJieQi(true)}前${bazi.getNextJieQi(true).getSolar().subtractMinute(bazi.getSolar()) ~/ 1440}天${(bazi.getNextJieQi(true).getSolar().subtractMinute(bazi.getSolar()) % 1440) ~/ 60}小时',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    color: const Color(0xffffffff),
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                      vertical: 20.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${bazi.getPrevJieQi(true).getName()}：${bazi.getPrevJieQi(true).getSolar().toYmdHms()}',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${bazi.getNextJieQi(true).getName()}：${bazi.getNextJieQi(true).getSolar().toYmdHms()}',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${bazi.getNextJieQi(true).getSolar().getLunar().getNextJieQi(true)}：${bazi.getNextJieQi(true).getSolar().getLunar().getNextJieQi(true).getSolar().toYmdHms()}',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    color: const Color(0xfff9f9f9),
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                      vertical: 20.w,
                    ),
                    child: Text(
                      '命主五行：${bazi.getDayGan()}${StemsAndBranches.getElementByLabel(bazi.getDayGan()).element.label}',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:'星座：',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${bazi.getSolar().getXingZuo()}座',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]
                          )
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:'星宿：',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${bazi.getXiu()}宿(${bazi.getGong()}宫${bazi.getShou()})',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                              ]
                          )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.w),
                    color: const Color(0xfff9f9f9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:'胎元：',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${e.getTaiYuan()}(${e.getTaiYuanNaYin()})',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]
                          )
                        ),
                        Text(
                          '空亡: ${bazi.getYearXunKong()}(年)${bazi.getDayXunKong()}(日)',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:'命宫：',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${e.getMingGong()}(${e.getMingGongNaYin()})',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]
                          )
                        ),
                        Text(
                          '胎息：${e.getTaiXi()}(${e.getTaiXiNaYin()})',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    color: const Color(0xfff9f9f9),
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                      vertical: 20.w,
                    ),
                    child: Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                text:'身宫：',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${e.getShenGong()}(${e.getShenGongNaYin()})',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]
                        )
                    ),
                  ),
                  SizedBox(height: 40.w)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
