import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lunar/calendar/Solar.dart';
import 'package:horosa/models/bazi.dart';
import 'package:horosa/models/horosa.dart';
import 'package:horosa/providers/config.dart';
import 'package:horosa/utils/bazi_rel.dart';
import 'package:horosa/utils/utils.dart';
import 'package:lunar/calendar/EightChar.dart';
import 'package:provider/provider.dart';
import 'hidden_stems_text.dart';
import 'pillar_interaction_line.dart';
import 'plain_text.dart';
import 'stems_or_branch_text.dart';
import 'pillar_interaction.dart';
import 'package:horosa/constants/shen_sha.dart';

/// 原命局
class NatalChartScreen extends StatefulWidget {
  const NatalChartScreen({super.key, required this.form});

  final BaZiInput form;

  @override
  State<NatalChartScreen> createState() => _NatalChartScreenState();
}

class _NatalChartScreenState extends State<NatalChartScreen> {
  late BaZi bazi;
  late EightChar eightChar;
  late StemsOrBranchElement yearStems;
  late StemsOrBranchElement yearBranch;
  late StemsOrBranchElement monthStems;
  late StemsOrBranchElement monthBranch;
  late StemsOrBranchElement dayStems;
  late StemsOrBranchElement dayBranch;
  late StemsOrBranchElement timeStems;
  late StemsOrBranchElement timeBranch;
  late List<StemsOrBranchElement> stems;
  late List<StemsOrBranchElement> branches;
  List<List<List<int>>> stemsInteractions = [];
  List<List<List<int>>> branchInteractions = [];
  late List<String> yearPillarsShenSha;
  late List<String> monthPillarsShenSha;
  late List<String> dayPillarsShenSha;
  late List<String> timePillarsShenSha;
  late String complexStemsRelation;
  late String branchFortune;

  String genderToStr() {
    return widget.form.gender.value == 1 ? '（乾造）' : '（坤造）';
  }

  // 使用 Map 去重
  List<HiddenStemsText> mergeListToHiddenStemsText(
      List<String> a, List<String> b) {
    List<HiddenStemsText> result = [];
    for (int i = 0; i < a.length; i++) {
      result.add(HiddenStemsText(
        stems: Stems.getStemsByLabel(a[i]),
        label: b[i],
      ));
    }
    return result;
  }

  void handler() {
    yearStems = Stems.getStemsByLabel(eightChar.getYearGan());
    yearBranch = Branches.getBranchByLabel(eightChar.getYearZhi());
    monthStems = Stems.getStemsByLabel(eightChar.getMonthGan());
    monthBranch = Branches.getBranchByLabel(eightChar.getMonthZhi());
    dayStems = Stems.getStemsByLabel(eightChar.getDayGan());
    dayBranch = Branches.getBranchByLabel(eightChar.getDayZhi());
    timeStems = Stems.getStemsByLabel(eightChar.getTimeGan());
    timeBranch = Branches.getBranchByLabel(eightChar.getTimeZhi());

    List<List<int>> stemsPiles = [];
    stems = [
      yearStems,
      monthStems,
      dayStems,
      timeStems
    ];
    List<List<int>> branchPiles = [];
    branches = [
      yearBranch,
      monthBranch,
      dayBranch,
      timeBranch
    ];
    for (int i = 0; i < stems.length; i++) {
      StemsOrBranchElement a = stems[i];
      for (int j = i + 1; j < stems.length; j++) {
        StemsOrBranchElement b = stems[j];
        if (Stems.getBothOfStemsRS(a, b) != SOBRelShip.none) {
          stemsPiles.add([2 * i + 1, 2 * j + 1]);
        }
      }
    }
    for (int i = 0; i < branches.length; i++) {
      StemsOrBranchElement a = branches[i];
      for (int j = i + 1; j < branches.length; j++) {
        StemsOrBranchElement b = branches[j];
        if (Branches.getBothOfBranchRS(a, b) != SOBRelShip.none) {
          branchPiles.add([2 * i + 1, 2 * j + 1]);
        }
      }
    }

    if(context.read<ConfigProvider>().showBaZiSABLine) {
      stemsInteractions = partitionIntervals(stemsPiles).reversed.toList();
      branchInteractions = partitionIntervals(branchPiles).reversed.toList();
    }

    List<String> calcYearPillarsShenSha() {
      List<String> result = [];
      // 年干 > 年支
      List<String> ysyb = ShenShaUtil
              .BAZI_DAY_YEAR_STEMS['${yearStems.label}${yearBranch.label}'] ??
          [];
      // 日干 > 年支
      List<String> dsyb =
          ShenShaUtil.BAZI_DAY_STEMS['${dayStems.label}${yearBranch.label}'] ??
              [];
      // 日支 > 年支
      List<String> dbyb1 = ShenShaUtil
              .BAZI_YEAR_DAY_BRANCH['${dayBranch.label}${yearBranch.label}'] ??
          [];
      List<String> dbyb2 =
          ShenShaUtil.BAZI_DAY_BRANCH['${dayBranch.label}${yearStems.label}'] ??
              [];
      // 月支 > 年干
      List<String> mbys = ShenShaUtil
              .BAZI_MONTH_STEMS['${monthBranch.label}${yearStems.label}'] ??
          [];
      // 月支 > 年支
      List<String> mbyb = ShenShaUtil
              .BAZI_MONTH_BRANCH['${monthBranch.label}${yearBranch.label}'] ??
          [];

      // 将以上全部结果合并，并去重
      result.addAll(ysyb);
      result.addAll(dsyb);
      result.addAll(dbyb1);
      result.addAll(dbyb2);
      result.addAll(mbys);
      result.addAll(mbyb);
      result = result.toSet().toList();

      return result;
    }

    yearPillarsShenSha = calcYearPillarsShenSha();

    List<String> calcMonthPillarsShenSha() {
      List<String> result = [];
      // 日干 > 月支
      List<String> dsmbI = ShenShaUtil
              .BAZI_DAY_YEAR_STEMS['${dayStems.label}${monthBranch.label}'] ??
          [];
      List<String> dsmbII =
          ShenShaUtil.BAZI_DAY_STEMS['${dayStems.label}${monthBranch.label}'] ??
              [];
      // 年干 > 月支
      List<String> ysmb = ShenShaUtil
              .BAZI_DAY_YEAR_STEMS['${yearStems.label}${monthBranch.label}'] ??
          [];
      // 年支 > 月支
      List<String> ybmbI = ShenShaUtil.BAZI_YEAR_DAY_BRANCH[
              '${yearBranch.label}${monthBranch.label}'] ??
          [];
      List<String> ybmbII = ShenShaUtil
              .BAZI_YEAR_BRANCH['${yearBranch.label}${monthBranch.label}'] ??
          [];
      // 日支 > 月支
      List<String> dbmbI = ShenShaUtil
              .BAZI_YEAR_DAY_BRANCH['${dayBranch.label}${monthBranch.label}'] ??
          [];
      List<String> dbmbII = ShenShaUtil
              .BAZI_DAY_BRANCH['${dayBranch.label}${monthBranch.label}'] ??
          [];
      // 月支 > 月干
      List<String> mbms = ShenShaUtil
              .BAZI_MONTH_STEMS['${monthBranch.label}${monthStems.label}'] ??
          [];

      result.addAll(dsmbI);
      result.addAll(dsmbII);
      result.addAll(ysmb);
      result.addAll(ybmbI);
      result.addAll(ybmbII);
      result.addAll(dbmbI);
      result.addAll(dbmbII);
      result.addAll(mbms);

      result = result.toSet().toList();

      return result;
    }

    monthPillarsShenSha = calcMonthPillarsShenSha();

    List<String> calcDayPillarsShenSha() {
      List<String> result = [];
      // 年干 > 日支
      List<String> ysdbI = ShenShaUtil
              .BAZI_DAY_YEAR_STEMS['${yearStems.label}${dayBranch.label}'] ??
          [];
      List<String> ysdbII = ShenShaUtil
              .BAZI_YEAR_BRANCH['${yearStems.label}${dayBranch.label}'] ??
          [];
      // 日干 > 日支
      List<String> dsdbI = ShenShaUtil
              .BAZI_DAY_YEAR_STEMS['${dayStems.label}${dayBranch.label}'] ??
          [];
      List<String> dsdbII =
          ShenShaUtil.BAZI_DAY_STEMS['${dayStems.label}${dayBranch.label}'] ??
              [];
      // 年支 > 日支
      List<String> ybdbI = ShenShaUtil
              .BAZI_YEAR_DAY_BRANCH['${yearBranch.label}${dayBranch.label}'] ??
          [];
      List<String> ybdbII = ShenShaUtil
              .BAZI_YEAR_BRANCH['${yearBranch.label}${dayBranch.label}'] ??
          [];
      // 月支 > 日干
      List<String> mbds = ShenShaUtil
              .BAZI_MONTH_STEMS['${monthBranch.label}${dayStems.label}'] ??
          [];
      // 月支 > 日支
      List<String> mbdb = ShenShaUtil
              .BAZI_MONTH_BRANCH['${monthBranch.label}${dayBranch.label}'] ??
          [];

      result.addAll(ysdbI);
      result.addAll(ysdbII);
      result.addAll(dsdbI);
      result.addAll(dsdbII);
      result.addAll(ybdbI);
      result.addAll(ybdbII);
      result.addAll(mbds);
      result.addAll(mbdb);

      result = result.toSet().toList();

      return result;
    }

    dayPillarsShenSha = calcDayPillarsShenSha();

    List<String> calcTimePillarsShenSha() {
      List<String> result = [];
      // 年干 > 时支
      List<String> ystb = ShenShaUtil
              .BAZI_DAY_YEAR_STEMS['${yearStems.label}${timeBranch.label}'] ??
          [];
      // 日干 > 时支
      List<String> dstbI = ShenShaUtil
              .BAZI_DAY_YEAR_STEMS['${dayStems.label}${timeBranch.label}'] ??
          [];
      List<String> dstbII = ShenShaUtil
              .BAZI_DAY_BRANCH['${dayBranch.label}${timeBranch.label}'] ??
          [];
      // 年支 > 时支
      List<String> ybtbI = ShenShaUtil
              .BAZI_YEAR_DAY_BRANCH['${yearBranch.label}${timeBranch.label}'] ??
          [];
      List<String> ybtbII = ShenShaUtil
              .BAZI_YEAR_BRANCH['${yearBranch.label}${timeBranch.label}'] ??
          [];
      // 日支 > 时支
      List<String> dbtbI = ShenShaUtil
              .BAZI_YEAR_DAY_BRANCH['${dayBranch.label}${timeBranch.label}'] ??
          [];
      List<String> dbtbII = ShenShaUtil
              .BAZI_DAY_BRANCH['${dayBranch.label}${timeBranch.label}'] ??
          [];
      // 月支 > 时支
      List<String> mbtb = ShenShaUtil
              .BAZI_MONTH_BRANCH['${monthBranch.label}${timeBranch.label}'] ??
          [];
      // 月支 > 时干
      List<String> mbts = ShenShaUtil
              .BAZI_MONTH_STEMS['${monthBranch.label}${timeStems.label}'] ??
          [];

      result.addAll(ystb);
      result.addAll(dstbI);
      result.addAll(dstbII);
      result.addAll(ybtbI);
      result.addAll(ybtbII);
      result.addAll(dbtbI);
      result.addAll(dbtbII);
      result.addAll(mbtb);
      result.addAll(mbts);

      result = result.toSet().toList();

      return result;
    }

    timePillarsShenSha = calcTimePillarsShenSha();

    // 天干本命
    List<List<StemsOrBranchElement>> getStemsPermutation() {
      List<List<StemsOrBranchElement>> permutation = [];
      for (int i = 0; i < stems.length; i++) {
        for (int j = i + 1; j < stems.length; j++) {
          permutation.add([stems[i], stems[j]]);
        }
      }
      return permutation;
    }

    List<List<StemsOrBranchElement>> stemsPermutation = getStemsPermutation();
    complexStemsRelation = stemsPermutation
        .map((s) {
          return Stems.complexRelation((s[0] as Stems), (s[1] as Stems));
        })
        .where((r) => r.isNotEmpty)
        .toSet()
        .toList()
        .join(' ');

    branchFortune =
        BaZiRelUtil.getBaZiBranchRel(branches).toSet().toList().join(' ');
  }

  Solar _calculateASTSolar(Solar? birth, double? longitude, int gmtOffset) {
    if (birth == null || longitude == null) {
      return widget.form.birthday;
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
    return Solar.fromDate(ast);
  }
  // _calculateAST(bazi.getSolar(), form.birthplace.longitude, form.birthplace.gmtOffset)}

  @override
  void initState() {
    super.initState();
    bazi = BaZi(
        widget.form.useAST
            ? _calculateASTSolar(widget.form.birthday, widget.form.birthplace.longitude, widget.form.birthplace.gmtOffset).getLunar()
            : widget.form.birthday.getLunar()
    );
    eightChar = bazi.getEightChar();
    eightChar.setSect(1);
    handler();
  }

  @override
  Widget build(BuildContext context) {
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
                shadows: [
                  BoxShadow(
                    color: const Color(0x13222327),
                    blurRadius: 12.r,
                    offset: Offset(0, 8.w),
                    spreadRadius: -4.r,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.form.username.isNotEmpty ? widget.form.username : '无名氏'}${genderToStr()}',
                    style: TextStyle(
                      color: const Color(0xff222426),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.w,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '阳历：${bazi.getSolarToStr()}',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '阴历：${bazi.getLunarToStr()}',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    bazi = BaZi(bazi.lunar.getSolar().prevHour(2).getLunar());
                                    eightChar = bazi.getEightChar();
                                    eightChar.setSect(1);
                                    handler();
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/arrow-left-frame.svg',
                                  width: 40.w,
                                  height: 40.w,
                                )),
                            SizedBox(width: 14.w),
                            Text(
                              '2小时',
                              style: TextStyle(
                                color: const Color(0xfff8cc76),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    bazi = BaZi(bazi.lunar.getSolar().nextHour(2).getLunar());
                                    eightChar = bazi.getEightChar();
                                    eightChar.setSect(1);
                                    handler();
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/arrow-right-frame.svg',
                                  width: 40.w,
                                  height: 40.w,
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.w),
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
                padding: EdgeInsets.symmetric(vertical: 30.w),
                child: Table(
                  columnWidths: {
                    0: FixedColumnWidth(40.w),
                    1: FixedColumnWidth(108.w),
                    3: FixedColumnWidth(40.w),
                  },
                  children: [
                    TableRow(
                      children: [
                        const TableCell(child: SizedBox()),
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.w),
                            child: SizedBox(
                              height: 50.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '年柱',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Expanded(
                                    child: Text(
                                      '月柱',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Expanded(
                                    child: Text(
                                      '日柱',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Expanded(
                                    child: Text(
                                      '时柱',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),

                    /// 主星
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xfff9f9f9)),
                      children: [
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: SizedBox(
                            height: 60.w,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '主星',
                                style: TextStyle(
                                  color: const Color(0xff393b41),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: SizedBox(
                            height: 60.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    eightChar.getYearShiShenGan(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      eightChar.getMonthShiShenGan(),
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      widget.form.gender.value == 1
                                          ? '元男'
                                          : '元女',
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      eightChar.getTimeShiShenGan(),
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),

                    /// 天干合冲
                    ...stemsInteractions.map((row) {
                      IntervalFiller filler =
                          IntervalFiller(stems.length * 2 - 1, row)
                              .fillIntervalsWithIndex();
                      return TableRow(
                        children: [
                          const TableCell(child: SizedBox()),
                          const TableCell(child: SizedBox()),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.w),
                              child: SizedBox(
                                height: 36.w,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ...filler.intervals.map((item) {
                                      SOBCombOrConflict? interaction;
                                      if (filler.indices
                                              ?.containsKey(item.toString()) ??
                                          false) {
                                        interaction =
                                            Stems.getBothOfStemsCombOrConflict(
                                                stems[(item.first) ~/ 2],
                                                stems[(item.last) ~/ 2]);
                                      }
                                      return Expanded(
                                        flex: item.last - item.first + 1,
                                        child: filler.indices?.containsKey(
                                                    item.toString()) ??
                                                false
                                            ? Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 36.w),
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      final width =
                                                          constraints.maxWidth;
                                                      final height =
                                                          constraints.maxHeight;
                                                      return Stack(
                                                        children: [
                                                          CustomPaint(
                                                            size: Size(
                                                                width, height),
                                                            painter:
                                                                const PillarInteractionLine(),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Container(
                                                              width: 36.w,
                                                              height: 36.w,
                                                              decoration:
                                                                  ShapeDecoration(
                                                                      color: interaction
                                                                          ?.color,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.r),
                                                                      )),
                                                              child: Text(
                                                                interaction
                                                                        ?.label ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: interaction
                                                                              ?.value ==
                                                                          -1
                                                                      ? const Color(
                                                                          0xff393b41)
                                                                      : const Color(
                                                                          0xffffffff),
                                                                  fontSize:
                                                                      20.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  height: 32.w /
                                                                      20.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const TableCell(child: SizedBox()),
                        ],
                      );
                    }),

                    /// 天干
                    TableRow(
                      children: [
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: SizedBox(
                            height: 60.w,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '天干',
                                style: TextStyle(
                                  color: const Color(0xff393b41),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: SizedBox(
                            height: 60.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: yearStems)),
                                Expanded(
                                  child: PillarInteraction(
                                    a: yearStems,
                                    b: monthStems,
                                  ),
                                ),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: monthStems)),
                                Expanded(
                                  child: PillarInteraction(
                                    a: monthStems,
                                    b: dayStems,
                                  ),
                                ),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: dayStems)),
                                Expanded(
                                  child: PillarInteraction(
                                    a: dayStems,
                                    b: timeStems,
                                  ),
                                ),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: timeStems)),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),

                    /// 干支五行关系
                    TableRow(
                      children: [
                        const TableCell(child: SizedBox()),
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: SizedBox(
                            height: 60.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: yearStems,
                                    b: yearBranch,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: monthStems,
                                    b: monthBranch,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: dayStems,
                                    b: dayBranch,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: timeStems,
                                    b: timeBranch,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),

                    /// 地支
                    TableRow(
                      children: [
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: SizedBox(
                            height: 60.w,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '地支',
                                style: TextStyle(
                                  color: const Color(0xff393b41),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: SizedBox(
                            height: 60.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: yearBranch)),
                                Expanded(
                                  child: PillarInteraction(
                                    a: yearBranch,
                                    b: monthBranch,
                                  ),
                                ),
                                Expanded(
                                    child: StemsOrBranchText(
                                        element: monthBranch)),
                                Expanded(
                                  child: PillarInteraction(
                                    a: monthBranch,
                                    b: dayBranch,
                                  ),
                                ),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: dayBranch)),
                                Expanded(
                                  child: PillarInteraction(
                                    a: dayBranch,
                                    b: timeBranch,
                                  ),
                                ),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: timeBranch)),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),

                    /// 地支关系
                    ...branchInteractions.map((row) {
                      IntervalFiller filler =
                          IntervalFiller(stems.length * 2 - 1, row)
                              .fillIntervalsWithIndex();
                      return TableRow(
                        children: [
                          const TableCell(child: SizedBox()),
                          const TableCell(child: SizedBox()),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.w),
                              child: SizedBox(
                                height: 36.w,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ...filler.intervals.map((item) {
                                      SOBCombOrConflict? interaction;
                                      if (filler.indices
                                              ?.containsKey(item.toString()) ??
                                          false) {
                                        interaction = Branches
                                            .getBothOfBranchCombOrConflict(
                                                branches[(item.first) ~/ 2],
                                                branches[(item.last) ~/ 2]);
                                      }
                                      return Expanded(
                                        flex: item.last - item.first + 1,
                                        child: filler.indices?.containsKey(
                                                    item.toString()) ??
                                                false
                                            ? Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 36.w),
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      final width =
                                                          constraints.maxWidth;
                                                      final height =
                                                          constraints.maxHeight;
                                                      return Stack(
                                                        children: [
                                                          CustomPaint(
                                                            size: Size(
                                                                width, height),
                                                            painter: const PillarInteractionLine(
                                                                direction:
                                                                    PillarDirection
                                                                        .up),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Container(
                                                              width: 36.w,
                                                              height: 36.w,
                                                              decoration:
                                                                  ShapeDecoration(
                                                                      color: interaction
                                                                          ?.color,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18.r),
                                                                      )),
                                                              child: Text(
                                                                interaction
                                                                        ?.label ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: interaction
                                                                              ?.value ==
                                                                          -1
                                                                      ? const Color(
                                                                          0xff393b41)
                                                                      : const Color(
                                                                          0xffffffff),
                                                                  fontSize:
                                                                      20.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  height: 32.w /
                                                                      20.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const TableCell(child: SizedBox()),
                        ],
                      );
                    }),

                    /// 藏干
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xfff9f9f9)),
                      children: [
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '藏干',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xff393b41),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: SizedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: Wrap(
                                      runSpacing: 10.w,
                                      children: mergeListToHiddenStemsText(
                                          eightChar.getYearHideGan(),
                                          bazi
                                              .getEightChar()
                                              .getYearShiShenZhi()),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: Wrap(
                                      runSpacing: 10.w,
                                      children: mergeListToHiddenStemsText(
                                          eightChar.getMonthHideGan(),
                                          bazi
                                              .getEightChar()
                                              .getMonthShiShenZhi()),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: Wrap(
                                      runSpacing: 10.w,
                                      children: mergeListToHiddenStemsText(
                                          eightChar.getDayHideGan(),
                                          bazi
                                              .getEightChar()
                                              .getDayShiShenZhi()),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: Wrap(
                                      runSpacing: 10.w,
                                      children: mergeListToHiddenStemsText(
                                          eightChar.getTimeHideGan(),
                                          bazi
                                              .getEightChar()
                                              .getTimeShiShenZhi()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),

                    /// 神煞
                    TableRow(
                      children: [
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '神煞',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xff393b41),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: SizedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: Column(
                                      children: List.generate(
                                          yearPillarsShenSha.length, (i) {
                                        return Column(
                                          children: [
                                            PlainText(
                                                label: yearPillarsShenSha[i]),
                                            Visibility(
                                              visible: i !=
                                                  yearPillarsShenSha.length - 1,
                                              child: SizedBox(height: 20.w),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: Column(
                                      children: List.generate(
                                          monthPillarsShenSha.length, (i) {
                                        return Column(
                                          children: [
                                            PlainText(
                                                label: monthPillarsShenSha[i]),
                                            Visibility(
                                              visible: i !=
                                                  monthPillarsShenSha.length -
                                                      1,
                                              child: SizedBox(height: 20.w),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: Column(
                                      children: List.generate(
                                          dayPillarsShenSha.length, (i) {
                                        return Column(
                                          children: [
                                            PlainText(
                                                label: dayPillarsShenSha[i]),
                                            Visibility(
                                              visible: i !=
                                                  dayPillarsShenSha.length - 1,
                                              child: SizedBox(height: 20.w),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: Column(
                                      children: List.generate(
                                          timePillarsShenSha.length, (i) {
                                        return Column(
                                          children: [
                                            PlainText(
                                                label: timePillarsShenSha[i]),
                                            Visibility(
                                              visible: i !=
                                                  timePillarsShenSha.length - 1,
                                              child: SizedBox(height: 20.w),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.w),
            Container(
              width: 1.sw,
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
                padding: EdgeInsets.only(left: 40.w, top: 30.w, bottom: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '天干本命：',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: complexStemsRelation.isNotEmpty ? complexStemsRelation : '无合克关系',
                            style: TextStyle(
                              color: const Color(0xfff8cc76),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.w),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '地支本命：',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: branchFortune,
                            style: TextStyle(
                              color: const Color(0xfff8cc76),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
