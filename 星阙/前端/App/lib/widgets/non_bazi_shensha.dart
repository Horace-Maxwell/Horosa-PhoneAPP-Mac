import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/constants/shen_sha.dart';
import 'package:lunar/lunar.dart';

class NonBaziShensha extends StatelessWidget {
  const NonBaziShensha({super.key, required this.lunar});

  final Lunar lunar;

  String getShenShaBranch(Map<String, Map<String, List<String>>> shenShaMap,
      String shenSha, String sob) {
    List<String>? branch = shenShaMap[shenSha]?[sob];
    if (branch != null) {
      return branch.join('');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    EightChar e = EightChar.fromLunar(lunar);
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '日禄-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_DAY_STEMS, '日禄', e.getDayGan()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '日德-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_DAY_STEMS, '日德', e.getDayGan()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '天马-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '天马', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '日马-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_DAY_BRANCH, '日马', e.getDayZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '年马-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_YEAR_BRANCH, '年马', e.getYearZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '桃花-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_DAY_BRANCH, '桃花', e.getDayZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '破碎-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_DAY_BRANCH, '破碎', e.getDayZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '生气-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '生气', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '死气-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '死气', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '病符-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_YEAR_BRANCH, '病符', e.getYearZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '血支-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '血支', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '孤辰-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_YEAR_BRANCH, '孤辰', e.getYearZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '寡宿-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_YEAR_BRANCH, '寡宿', e.getYearZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '丧门-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_YEAR_BRANCH, '丧门', e.getYearZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '吊客-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_YEAR_BRANCH, '吊客', e.getYearZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '成神-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '成神', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '会神-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '会神', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '解神-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '解神', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '天目-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '天目', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '医星-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '医星', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '月厌-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '月厌', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '月破-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '月破', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '贼神-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '贼神', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '贵人-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_DAY_STEMS, '贵人', e.getDayGan()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '游都-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_DAY_STEMS, '游都', e.getDayGan()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '文昌-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_DAY_STEMS, '文昌', e.getDayGan()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '丧车-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_MONTH_BRANCH, '丧车', e.getMonthZhi()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                softWrap: false,
                overflow: TextOverflow.visible,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '幕贵-',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: getShenShaBranch(
                          ShenShaUtil.OTHER_DAY_STEMS, '幕贵', e.getDayGan()),
                      style: TextStyle(
                        color: const Color(0x99393b41),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
