import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/constants/shen_sha.dart';
import 'package:horosa/models/bazi.dart';
import 'package:horosa/models/horosa.dart';
import 'package:horosa/providers/config.dart';
import 'package:horosa/utils/bazi_rel.dart';
import 'package:horosa/utils/utils.dart';
import 'package:lunar/lunar.dart';
import 'package:provider/provider.dart';
import 'hidden_stems_text.dart';
import 'pillar_interaction.dart';
import 'pillar_interaction_line.dart';
import 'plain_text.dart';
import 'stems_or_branch_text.dart';

enum Direction {
  up,
  down,
  left,
  right,
}

/// 细盘
class DetailedChartScreen extends StatefulWidget {
  const DetailedChartScreen({super.key, required this.form});

  final BaZiInput form;

  @override
  State<DetailedChartScreen> createState() => _DetailedChartScreenState();
}

class _DetailedChartScreenState extends State<DetailedChartScreen> {
  late BaZi bazi;
  late EightChar eightChar;
  late Yun yun;
  late List<DaYun> daYun;
  late DaYun selectedDaYun;
  late List<LiuNian> liuNian;
  late LiuNian selectedLiuNian;
  late List<Solar> liuYue;
  late Solar selectedLiuYue;
  late List<Solar> liuRi;
  late Solar selectedLiuRi;

  late ScrollController daYunController;
  late ScrollController liuNianController;
  late ScrollController liuYueController;
  late ScrollController liuRiController;

  late StemsOrBranchElement liuNianStems;
  late StemsOrBranchElement liuNianBranch;
  late StemsOrBranchElement daYunStems;
  late StemsOrBranchElement daYunBranch;
  late StemsOrBranchElement yearStems;
  late StemsOrBranchElement yearBranch;
  late StemsOrBranchElement monthStems;
  late StemsOrBranchElement monthBranch;
  late StemsOrBranchElement dayStems;
  late StemsOrBranchElement dayBranch;
  late StemsOrBranchElement timeStems;
  late StemsOrBranchElement timeBranch;
  late String stemsNatal;
  late String branchNatal;
  late String stemsFortune;
  late String branchFortune;
  late String jiaoYun;

  List<List<int>> stemsPiles = [];
  late List<StemsOrBranchElement> stems = [];
  List<List<int>> branchPiles = [];
  late List<StemsOrBranchElement> branches = [];

  List<List<List<int>>> stemsInteractions = [];
  List<List<List<int>>> branchInteractions = [];

  List<HiddenStemsText> mergeListToHiddenStemsText(
      List<String> a, List<String> b) {
    List<HiddenStemsText> result = [];
    for (int i = 0; i < a.length; i++) {
      String label = b[i];
      result.add(HiddenStemsText(
        stems: Stems.getStemsByLabel(a[i]),
        label: shiShenMap[label] ?? label,
      ));
    }
    return result;
  }

  // 计算十神
  String csh(String stems) =>
      shiShenMap[Horosa.getShiShenBySABStr('${dayStems.label}$stems')]!;

  // 计算藏干
  String hs(String branch) =>
      Horosa.getHiddenStems(Branches.getBranchByLabel(branch).label).first;

  // 计算流日
  List<Solar> getLiuRi(int year, int month) {
    Lunar lunar = Solar.fromYmd(year, month, 1).getLunar();
    int startDay = lunar.getPrevJie(true).getSolar().getDay();
    int endDay = lunar.getNextJie(true).getSolar().getDay();
    List<Solar> days = SolarMonth.fromYm(year, month).getDays();
    List<Solar> nextDays = SolarMonth.fromYm(
            month < 12 ? year : year + 1, month < 12 ? month + 1 : 1)
        .getDays();

    List<Solar> result = [];
    for (int i = 0; i < days.length; i++) {
      if (days[i].getDay() >= startDay) {
        result.add(days[i]);
      }
    }
    for (int i = 0; i < nextDays.length; i++) {
      if (nextDays[i].getDay() < endDay) {
        result.add(nextDays[i]);
      }
    }
    return result;
  }

  void change() {
    liuNianStems =
        Stems.getStemsByLabel(selectedLiuNian.getGanZhi().split('').first);
    liuNianBranch =
        Branches.getBranchByLabel(selectedLiuNian.getGanZhi().split('').last);
    daYunStems =
        Stems.getStemsByLabel(selectedDaYun.getGanZhi().split('').first);
    daYunBranch =
        Branches.getBranchByLabel(selectedDaYun.getGanZhi().split('').last);
    update();
  }

  void update() {
    stemsPiles = [];
    branchPiles = [];

    stems = [
      liuNianStems,
      daYunStems,
      yearStems,
      monthStems,
      dayStems,
      timeStems
    ];
    branches = [
      liuNianBranch,
      daYunBranch,
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
  }

  String calcShenSha(StemsBranchItem item) {
    List<String> result = [];
    // 年干 > 支
    List<String> ystb = ShenShaUtil
            .BAZI_DAY_YEAR_STEMS['${yearStems.label}${item.branch!.label}'] ??
        [];
    // 日干 > 支
    List<String> dstbI = ShenShaUtil
            .BAZI_DAY_YEAR_STEMS['${dayStems.label}${item.branch!.label}'] ??
        [];
    List<String> dstbII = ShenShaUtil
            .BAZI_DAY_BRANCH['${dayBranch.label}${item.branch!.label}'] ??
        [];
    // 年支 > 支
    List<String> ybtbI = ShenShaUtil
            .BAZI_YEAR_DAY_BRANCH['${yearBranch.label}${item.branch!.label}'] ??
        [];
    List<String> ybtbII = ShenShaUtil
            .BAZI_YEAR_BRANCH['${yearBranch.label}${item.branch!.label}'] ??
        [];
    // 日支 > 支
    List<String> dbtbI = ShenShaUtil
            .BAZI_YEAR_DAY_BRANCH['${dayBranch.label}${item.branch!.label}'] ??
        [];
    List<String> dbtbII = ShenShaUtil
            .BAZI_DAY_BRANCH['${dayBranch.label}${item.branch!.label}'] ??
        [];
    // 月支 > 支
    List<String> mbtb = ShenShaUtil
            .BAZI_MONTH_BRANCH['${monthBranch.label}${item.branch!.label}'] ??
        [];
    // 月支 > 干
    List<String> mbts = ShenShaUtil
            .BAZI_MONTH_STEMS['${monthBranch.label}${item.stems!.label}'] ??
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

    return result.join(' ');
  }

  List<Solar> handleLiuYue(LiuNian nian) {
    List<LiuYue> months = nian.getYear() == bazi.lunar.getSolar().getYear()
        ? nian
        .getLiuYue()
        .where((element) =>
    element.getIndex() + 1 >= bazi.lunar.getSolar().getMonth())
        .toList()
        : nian.getLiuYue();
    List<Solar> result = [];
    Map<String, bool> seen = {};

    for(LiuYue month in months) {
      Solar solar = Solar.fromYmd(nian.getYear(), month.getIndex() + 1, 1);
      String jieqi = solar.getLunar()
          .getNextJie(true)
          .getName();
      if(month.getIndex() == 0 && jieqi == '小寒') {
        continue;
      }

      if(!seen.containsKey(jieqi)) {
        seen[jieqi] = true;
        result.add(solar);
      }

      if(month == months.last && jieqi == '大雪') {
        Solar s = Solar.fromYmd(nian.getYear() + 1, 1, 1);
        result.add(s);
      }
    }

    return result.toList();
  }

  DaYun initSelectedDaYun() {
    DaYun? yun;
    for (DaYun element in daYun) {
      List<LiuNian> years = element.getLiuNian().where((year) => year.getYear() == DateTime.now().year).toList();
      if(years.isNotEmpty) {
        yun = element;
        break;
      }
    }

    if(yun == null) {
      return daYun.first;
    }

    return yun;
  }

  @override
  void initState() {
    super.initState();
    daYunController = ScrollController();
    liuNianController = ScrollController();
    liuYueController = ScrollController();
    liuRiController = ScrollController();

    bazi = BaZi(widget.form.birthday.getLunar());
    eightChar = bazi.getEightChar();
    eightChar.setSect(1);
    yun = eightChar.getYun(widget.form.gender.value);
    daYun = yun.getDaYun();
    
    selectedDaYun = initSelectedDaYun();
    
    String jiaoYunStemsStr = daYun[1].getLiuNian().first.getGanZhi().split('').first;
    Stems jiaoYunStemsComb = Stems.getStemsByComb(Stems.getStemsByLabel(jiaoYunStemsStr));
    jiaoYun = '逢$jiaoYunStemsStr、${jiaoYunStemsComb.label}年${yun.getLunar().getPrevJie(true)}后${yun.getLunar().getSolar().subtract(yun.getLunar().getPrevJie(true).getSolar())}天交大运';
    liuNian = selectedDaYun.getLiuNian();
    selectedLiuNian = liuNian.firstWhere((element) => element.getYear() == DateTime.now().year, orElse: () => liuNian.first);
    liuYue = handleLiuYue(selectedLiuNian);
    selectedLiuYue = liuYue.firstWhere((element) => element.getMonth() == DateTime.now().month, orElse: () => liuYue.first);
    liuRi = getLiuRi(bazi.getSolar().getYear(), bazi.getSolar().getMonth());
    selectedLiuRi = liuRi.firstWhere((element) => element.getDay() == DateTime.now().day, orElse: () => liuRi.first);

    // 在初始化时滚动到指定位置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      daYunController.jumpTo(64.w * selectedDaYun.getIndex());
      liuNianController.jumpTo(64.w * selectedLiuNian.getIndex());
      liuYueController.jumpTo(64.w * selectedLiuYue.getMonth());
      liuRiController.jumpTo(64.w * (selectedLiuRi.getDay() - liuRi.first.getDay()));
    });

    XiaoYun xiaoYun = selectedDaYun.getXiaoYun().first;

    liuNianStems =
        Stems.getStemsByLabel(selectedLiuNian.getGanZhi().split('').first);
    liuNianBranch =
        Branches.getBranchByLabel(selectedLiuNian.getGanZhi().split('').last);
    daYunStems = Stems.getStemsByLabel((selectedDaYun.getGanZhi().isEmpty ? xiaoYun.getGanZhi() : selectedDaYun.getGanZhi()).split('').first);
    daYunBranch = Branches.getBranchByLabel((selectedDaYun.getGanZhi().isEmpty ? xiaoYun.getGanZhi() : selectedDaYun.getGanZhi()).split('').last);
    yearStems = Stems.getStemsByLabel(eightChar.getYearGan());
    yearBranch = Branches.getBranchByLabel(eightChar.getYearZhi());
    monthStems = Stems.getStemsByLabel(eightChar.getMonthGan());
    monthBranch = Branches.getBranchByLabel(eightChar.getMonthZhi());
    dayStems = Stems.getStemsByLabel(eightChar.getDayGan());
    dayBranch = Branches.getBranchByLabel(eightChar.getDayZhi());
    timeStems = Stems.getStemsByLabel(eightChar.getTimeGan());
    timeBranch = Branches.getBranchByLabel(eightChar.getTimeZhi());
    update();

    stemsFortune = BaZiRelUtil.getBaZiStemRelWithoutControl(stems).join(' ');
    stemsNatal = BaZiRelUtil.getBaZiStemRelWithoutControl([
      yearStems,
      monthStems,
      dayStems,
      timeStems,
    ]).join(' ');
    branchNatal = BaZiRelUtil.getBaZiBranchRel([
      yearBranch,
      monthBranch,
      dayBranch,
      timeBranch,
    ]).toSet().toList().join(' ');
    branchFortune =
        BaZiRelUtil.getBaZiBranchRel(branches).toSet().toList().join(' ');
  }

  @override
  void dispose() {
    daYunController.dispose();
    liuNianController.dispose();
    liuYueController.dispose();
    liuRiController.dispose();
    super.dispose();
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
                    0: FixedColumnWidth(30.w),
                    1: FixedColumnWidth(80.w),
                    3: FixedColumnWidth(30.w),
                  },
                  children: [
                    TableRow(
                      children: [
                        const TableCell(child: SizedBox()),
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: SizedBox(
                            height: 48.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '流年',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: const Color(0xff8d8d8d),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Text(
                                    '大运',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: const Color(0xff8d8d8d),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                        child: Container(
                                            width: 2.w,
                                            color: const Color(0xffe5e5e5)))),
                                Expanded(
                                  child: Text(
                                    '年柱',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: const Color(0xff8d8d8d),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Text(
                                    '月柱',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: const Color(0xff8d8d8d),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Text(
                                    '日柱',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: const Color(0xff8d8d8d),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Text(
                                    '时柱',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: const Color(0xff8d8d8d),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
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
                                  color: const Color(0xff8d8d8d),
                                  fontSize: 24.sp,
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
                                    Horosa.getShiShenByBothOfStems(
                                        dayStems, liuNianStems),
                                    textAlign: TextAlign.center,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Text(
                                    Horosa.getShiShenByBothOfStems(
                                        dayStems, daYunStems),
                                    textAlign: TextAlign.center,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                        child: Container(
                                            width: 2.w,
                                            color: const Color(0xffe5e5e5)))),
                                Expanded(
                                  child: Text(
                                    eightChar.getYearShiShenGan(),
                                    textAlign: TextAlign.center,
                                    softWrap: false,
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
                                      textAlign: TextAlign.center,
                                      softWrap: false,
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
                                      textAlign: TextAlign.center,
                                      softWrap: false,
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
                                      textAlign: TextAlign.center,
                                      softWrap: false,
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
                                                      horizontal: 24.w),
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
                                  color: const Color(0xff8d8d8d),
                                  fontSize: 24.sp,
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
                                    child: StemsOrBranchText(
                                        element: liuNianStems)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: liuNianStems,
                                  b: daYunStems,
                                )),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: daYunStems)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: daYunStems,
                                  b: yearStems,
                                )),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: yearStems)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: yearStems,
                                  b: monthStems,
                                )),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: monthStems)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: monthStems,
                                  b: dayStems,
                                )),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: dayStems)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: dayStems,
                                  b: timeStems,
                                )),
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
                            height: 48.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: liuNianStems,
                                    b: liuNianBranch,
                                    size: 32.w,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: daYunStems,
                                    b: daYunBranch,
                                    size: 32.w,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: yearStems,
                                    b: yearBranch,
                                    size: 32.w,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: monthStems,
                                    b: monthBranch,
                                    size: 32.w,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: dayStems,
                                    b: dayBranch,
                                    size: 32.w,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: PillarInteraction(
                                    axis: Axis.vertical,
                                    a: timeStems,
                                    b: timeBranch,
                                    size: 32.w,
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
                      decoration: const BoxDecoration(color: Color(0xfff9f9f9)),
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
                                  color: const Color(0xff8d8d8d),
                                  fontSize: 24.sp,
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
                                    child: StemsOrBranchText(
                                        element: liuNianBranch)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: liuNianBranch,
                                  b: daYunBranch,
                                )),
                                Expanded(
                                    child: StemsOrBranchText(
                                        element: daYunBranch)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: daYunBranch,
                                  b: yearBranch,
                                )),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: yearBranch)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: yearBranch,
                                  b: monthBranch,
                                )),
                                Expanded(
                                    child: StemsOrBranchText(
                                        element: monthBranch)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: monthBranch,
                                  b: dayBranch,
                                )),
                                Expanded(
                                    child:
                                        StemsOrBranchText(element: dayBranch)),
                                Expanded(
                                    child: PillarInteraction(
                                  size: 32.w,
                                  a: dayBranch,
                                  b: timeBranch,
                                )),
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
                                                      horizontal: 24.w),
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
                                  color: const Color(0xff8d8d8d),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: SizedBox(
                            child: IntrinsicHeight(
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
                                            Horosa.getHiddenStems(
                                                liuNianBranch.label),
                                            Horosa.getShiShenBySAB(
                                                dayStems as Stems,
                                                liuNianBranch as Branches)),
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
                                            Horosa.getHiddenStems(
                                                daYunBranch.label),
                                            Horosa.getShiShenBySAB(
                                                dayStems as Stems,
                                                daYunBranch as Branches)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Center(
                                          child: Container(
                                              width: 2.w,
                                              color: const Color(0xffe5e5e5)))),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.w),
                                      child: Wrap(
                                        runSpacing: 10.w,
                                        children: mergeListToHiddenStemsText(
                                            eightChar.getYearHideGan(),
                                            eightChar.getYearShiShenZhi()),
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
                                            eightChar.getMonthShiShenZhi()),
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
                                            eightChar.getDayShiShenZhi()),
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
                                            eightChar.getTimeShiShenZhi()),
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

                    /// 纳音
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
                                '纳音',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xff8d8d8d),
                                  fontSize: 24.sp,
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
                                    child: PlainText(
                                        label: Horosa.getNaYinBySAB(
                                            liuNianStems, liuNianBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getNaYinBySAB(
                                            daYunStems, daYunBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getNaYinBySAB(
                                            yearStems, yearBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getNaYinBySAB(
                                            monthStems, monthBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getNaYinBySAB(
                                            dayStems, dayBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getNaYinBySAB(
                                            timeStems, timeBranch)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),

                    /// 星运
                    TableRow(
                      children: [
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '星运',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xff8d8d8d),
                                  fontSize: 24.sp,
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
                                    child: PlainText(
                                        label: Horosa.getSelfZuo(
                                            dayStems, liuNianBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getSelfZuo(
                                            dayStems, daYunBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label:
                                            eightChar.getYearDiShi()),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: bazi
                                            .getEightChar()
                                            .getMonthDiShi()),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label:
                                            eightChar.getDayDiShi()),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label:
                                            eightChar.getTimeDiShi()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),

                    /// 自坐
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
                                '自坐',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xff8d8d8d),
                                  fontSize: 24.sp,
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
                                    child: PlainText(
                                        label: Horosa.getSelfZuo(
                                            liuNianStems, liuNianBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getSelfZuo(
                                            daYunStems, daYunBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getSelfZuo(
                                            yearStems, yearBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getSelfZuo(
                                            monthStems, monthBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getSelfZuo(
                                            dayStems, dayBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getSelfZuo(
                                            timeStems, timeBranch)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const TableCell(child: SizedBox()),
                      ],
                    ),

                    /// 空亡
                    TableRow(
                      children: [
                        const TableCell(child: SizedBox()),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '空亡',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xff8d8d8d),
                                  fontSize: 24.sp,
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
                                    child: PlainText(
                                        label: Horosa.getXunKongBySAB(
                                            liuNianStems, liuNianBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: Horosa.getXunKongBySAB(
                                            daYunStems, daYunBranch)),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: bazi
                                            .getEightChar()
                                            .getYearXunKong()),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: bazi
                                            .getEightChar()
                                            .getMonthXunKong()),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: bazi
                                            .getEightChar()
                                            .getDayXunKong()),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.w),
                                    child: PlainText(
                                        label: bazi
                                            .getEightChar()
                                            .getTimeXunKong()),
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

            /// 大运
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '大\n运',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 92.w),
                            child: GestureDetector(
                              onTap: () {
                                Log.d("Tap detected");
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        contentPadding: EdgeInsets.zero,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 78.w),
                                                width: 1.sw - 72.w,
                                                decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(36.r),
                                                  ),
                                                ),
                                                child: Text(
                                                  '起运：出生后${yun.getStartYear()}年${yun.getStartMonth()}个月${yun.getStartDay()}天${yun.getStartHour()}小时\n交运：$jiaoYun',
                                                  style: TextStyle(
                                                    color: const Color(0xFF222426),
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 30.w,
                                                right: 30.w,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: SizedBox(
                                                    width: 72.w,
                                                    child: Text(
                                                      '关闭',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: const Color(0xff222426),
                                                        fontSize: 30.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                width: 40.w,
                                height: 20.w,
                                decoration: ShapeDecoration(
                                  color: const Color(0xfff8cc76),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '起运',
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: SizedBox(
                        height: 186.w,
                        child: ListView.builder(
                          controller: daYunController,
                          scrollDirection: Axis.horizontal, // 设置为横向滚动
                          itemCount: daYun.length, // 列表项数量
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDaYun = daYun[index];
                                  liuNian = daYun[index].getLiuNian();
                                  selectedLiuNian = liuNian.first;
                                  liuYue = handleLiuYue(liuNian.first);
                                  selectedLiuYue = liuYue.first;
                                  liuRi = getLiuRi(selectedLiuNian.getYear(),
                                      selectedLiuYue.getMonth());
                                  selectedLiuRi = liuRi.first;
                                  if (index == 0) {
                                    XiaoYun xiaoYun =
                                        selectedDaYun.getXiaoYun().first;

                                    liuNianStems = Stems.getStemsByLabel(
                                        selectedLiuNian
                                            .getGanZhi()
                                            .split('')
                                            .first);
                                    liuNianBranch = Branches.getBranchByLabel(
                                        selectedLiuNian
                                            .getGanZhi()
                                            .split('')
                                            .last);
                                    daYunStems = Stems.getStemsByLabel(
                                        xiaoYun.getGanZhi().split('').first);
                                    daYunBranch = Branches.getBranchByLabel(
                                        xiaoYun.getGanZhi().split('').last);
                                    update();
                                    liuNianController.jumpTo(0);
                                    liuYueController.jumpTo(0);
                                    liuRiController.jumpTo(0);
                                  } else {
                                    change();
                                  }
                                  stemsFortune =
                                      BaZiRelUtil.getBaZiStemRelWithoutControl(stems)
                                          .join(' ');
                                  branchFortune =
                                      BaZiRelUtil.getBaZiBranchRel(branches)
                                          .toSet()
                                          .toList()
                                          .join(' ');
                                });
                              },
                              child: SizedBox(
                                width: 64.w,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Visibility(
                                      visible: selectedDaYun.getIndex() ==
                                          daYun[index].getIndex(),
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
                                      visible: selectedDaYun.getIndex() ==
                                          daYun[index].getIndex(),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                daYun[index]
                                                    .getStartYear()
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff8d8d8d),
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 8.w),
                                              Text(
                                                index == 0
                                                    ? '${daYun[index].getStartAge()}-${daYun[index].getEndAge()}岁'
                                                    : '${daYun[index].getStartAge()}岁',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff8d8d8d),
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text.rich(TextSpan(children: [
                                                TextSpan(
                                                  text: daYun[index]
                                                          .getGanZhi()
                                                          .split('')
                                                          .isNotEmpty
                                                      ? daYun[index]
                                                          .getGanZhi()
                                                          .split('')
                                                          .first
                                                      : '小',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff222426),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: daYun[index]
                                                          .getGanZhi()
                                                          .split('')
                                                          .isNotEmpty
                                                      ? csh(daYun[index]
                                                          .getGanZhi()
                                                          .split('')
                                                          .first)
                                                      : '',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffc0281c),
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                                )
                                              ])),
                                              Text.rich(TextSpan(children: [
                                                TextSpan(
                                                  text: daYun[index]
                                                          .getGanZhi()
                                                          .split('')
                                                          .isNotEmpty
                                                      ? daYun[index]
                                                          .getGanZhi()
                                                          .split('')
                                                          .last
                                                      : '运',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff222426),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: daYun[index]
                                                          .getGanZhi()
                                                          .split('')
                                                          .isNotEmpty
                                                      ? csh(hs(daYun[index]
                                                          .getGanZhi()
                                                          .split('')
                                                          .last))
                                                      : '',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffc0281c),
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                                )
                                              ])),
                                            ],
                                          ),
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

            /// 流年
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
                        height: 204.w,
                        child: ListView.builder(
                          controller: liuNianController,
                          scrollDirection: Axis.horizontal, // 设置为横向滚动
                          itemCount: liuNian.length, // 列表项数量
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLiuNian = liuNian[index];
                                  liuYue = handleLiuYue(selectedLiuNian);
                                  selectedLiuYue = liuYue.first;
                                  liuRi = getLiuRi(selectedLiuNian.getYear(),
                                      selectedLiuYue.getMonth());
                                  selectedLiuRi = liuRi.first;
                                  if (selectedDaYun.getIndex() == 0) {
                                    XiaoYun xiaoYun =
                                        selectedDaYun.getXiaoYun()[index];

                                    liuNianStems = Stems.getStemsByLabel(
                                        selectedLiuNian
                                            .getGanZhi()
                                            .split('')
                                            .first);
                                    liuNianBranch = Branches.getBranchByLabel(
                                        selectedLiuNian
                                            .getGanZhi()
                                            .split('')
                                            .last);
                                    daYunStems = Stems.getStemsByLabel(
                                        xiaoYun.getGanZhi().split('').first);
                                    daYunBranch = Branches.getBranchByLabel(
                                        xiaoYun.getGanZhi().split('').last);
                                    update();
                                    liuYueController.jumpTo(0);
                                    liuRiController.jumpTo(0);
                                  } else {
                                    change();
                                  }
                                  stemsFortune =
                                      BaZiRelUtil.getBaZiStemRelWithoutControl(stems)
                                          .join(' ');
                                  branchFortune =
                                      BaZiRelUtil.getBaZiBranchRel(branches)
                                          .toSet()
                                          .toList()
                                          .join(' ');
                                });
                              },
                              child: SizedBox(
                                width: 64.w,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Visibility(
                                      visible: selectedLiuNian.getIndex() ==
                                          liuNian[index].getIndex(),
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
                                      visible: selectedLiuNian.getIndex() ==
                                          liuNian[index].getIndex(),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                liuNian[index]
                                                    .getYear()
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff8d8d8d),
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4.w),
                                              Text(
                                                '${liuNian[index].getAge()}岁',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff8d8d8d),
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text.rich(TextSpan(children: [
                                                TextSpan(
                                                  text: liuNian[index]
                                                      .getGanZhi()
                                                      .split('')
                                                      .first,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff222426),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: csh(liuNian[index]
                                                      .getGanZhi()
                                                      .split('')
                                                      .first),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffc0281c),
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                                )
                                              ])),
                                              Text.rich(TextSpan(children: [
                                                TextSpan(
                                                  text: liuNian[index]
                                                      .getGanZhi()
                                                      .split('')
                                                      .last,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff222426),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: csh(hs(liuNian[index]
                                                      .getGanZhi()
                                                      .split('')
                                                      .last)),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffc0281c),
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                                )
                                              ])),
                                            ],
                                          ),
                                          Text(
                                            selectedDaYun
                                                .getXiaoYun()[index]
                                                .getGanZhi(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xff8d8d8d),
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
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
                        height: 188.w,
                        child: ListView.builder(
                          controller: liuYueController,
                          scrollDirection: Axis.horizontal, // 设置为横向滚动
                          itemCount: liuYue.length, // 列表项数量
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLiuYue = liuYue[index];
                                  liuRi = getLiuRi(selectedLiuNian.getYear(),
                                      selectedLiuYue.getMonth());
                                  selectedLiuRi = liuRi.first;
                                  liuRiController.jumpTo(0);
                                });
                              },
                              child: SizedBox(
                                width: 64.w,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Visibility(
                                      visible: selectedLiuYue.getMonth() ==
                                          liuYue[index].getMonth(),
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
                                      visible: selectedLiuYue.getMonth() ==
                                          liuYue[index].getMonth(),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                Solar.fromYmd(
                                                        selectedLiuNian
                                                            .getYear(),
                                                        liuYue[index]
                                                                .getMonth(),
                                                        1)
                                                    .getLunar()
                                                    .getNextJie(true)
                                                    .getName(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff8d8d8d),
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 8.w),
                                              Text(
                                                '${Solar.fromYmd(selectedLiuNian.getYear(), liuYue[index].getMonth(), 1).getLunar().getNextJie(true).getSolar().getMonth()}/${Solar.fromYmd(selectedLiuNian.getYear(), liuYue[index].getMonth(), 1).getLunar().getNextJie(true).getSolar().getDay()}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff8d8d8d),
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text.rich(TextSpan(children: [
                                                TextSpan(
                                                  text: Solar.fromYmd(
                                                          selectedLiuNian
                                                              .getYear(),
                                                          liuYue[index]
                                                                  .getMonth(),
                                                          1)
                                                      .getLunar()
                                                      .getNextJie(true)
                                                      .getSolar()
                                                      .getLunar()
                                                      .getMonthGan(),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff222426),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: csh(Solar.fromYmd(
                                                          selectedLiuNian
                                                              .getYear(),
                                                          liuYue[index]
                                                                  .getMonth(),
                                                          1)
                                                      .getLunar()
                                                      .getNextJie(true)
                                                      .getSolar()
                                                      .getLunar()
                                                      .getMonthGan()),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffc0281c),
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                                )
                                              ])),
                                              Text.rich(TextSpan(children: [
                                                TextSpan(
                                                  text: Solar.fromYmd(
                                                          selectedLiuNian
                                                              .getYear(),
                                                          liuYue[index]
                                                                  .getMonth(),
                                                          1)
                                                      .getLunar()
                                                      .getNextJie(true)
                                                      .getSolar()
                                                      .getLunar()
                                                      .getMonthZhi(),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff222426),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: csh(hs(Solar.fromYmd(
                                                          selectedLiuNian
                                                              .getYear(),
                                                          liuYue[index]
                                                                  .getMonth(),
                                                          1)
                                                      .getLunar()
                                                      .getNextJie(true)
                                                      .getSolar()
                                                      .getLunar()
                                                      .getMonthZhi())),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffc0281c),
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                                )
                                              ])),
                                            ],
                                          ),
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
                        height: 148.w,
                        child: ListView.builder(
                          controller: liuRiController,
                          scrollDirection: Axis.horizontal, // 设置为横向滚动
                          itemCount: liuRi.length, // 列表项数量
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLiuRi = liuRi[index];
                                });
                              },
                              child: SizedBox(
                                width: 64.w,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Visibility(
                                      visible: selectedLiuRi.toFullString() ==
                                          liuRi[index].toFullString(),
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
                                      visible: selectedLiuRi.toFullString() ==
                                          liuRi[index].toFullString(),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${liuRi[index].getMonth()}/${liuRi[index].getDay()}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xff8d8d8d),
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text.rich(TextSpan(children: [
                                                TextSpan(
                                                  text: liuRi[index]
                                                      .getLunar()
                                                      .getDayGan(),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff222426),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: csh(liuRi[index]
                                                      .getLunar()
                                                      .getDayGan()),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffc0281c),
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                                )
                                              ])),
                                              Text.rich(TextSpan(children: [
                                                TextSpan(
                                                  text: liuRi[index]
                                                      .getLunar()
                                                      .getDayZhi(),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff222426),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: csh(hs(liuRi[index]
                                                      .getLunar()
                                                      .getDayZhi())),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffc0281c),
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1,
                                                  ),
                                                )
                                              ])),
                                            ],
                                          ),
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

            /// 运势、本命
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
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 天干运势
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '天干运势',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            stemsFortune.isNotEmpty  ? stemsFortune : '无合克关系',
                            softWrap: true,
                            style: TextStyle(
                              color: const Color(0xff393b41),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.w),

                    /// 地支运势
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '地支运势',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            branchFortune,
                            softWrap: true,
                            style: TextStyle(
                              color: const Color(0xff393b41),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.w),

                    /// 天干本命
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '天干本命',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            stemsNatal.isNotEmpty ? stemsNatal : '无合克关系',
                            softWrap: true,
                            style: TextStyle(
                              color: const Color(0xff393b41),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.w),

                    /// 地支本命
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '地支本命',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            branchNatal,
                            softWrap: true,
                            style: TextStyle(
                              color: const Color(0xff393b41),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.w),

            /// 大运神煞
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
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '大运神煞',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${daYunStems.label}${daYunBranch.label}：',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          calcShenSha(StemsBranchItem(
                            stems: daYunStems as Stems,
                            branch: daYunBranch as Branches,
                          )),
                          style: TextStyle(
                            color: const Color(0xff393b41),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.w),

            /// 流年神煞
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
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '流年神煞',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedLiuNian.getGanZhi()}：',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          calcShenSha(StemsBranchItem(
                            stems: liuNianStems as Stems,
                            branch: liuNianBranch as Branches,
                          )),
                          style: TextStyle(
                            color: const Color(0xff393b41),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.w),

            /// 流月神煞
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
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '流月神煞',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedLiuYue.getLunar().getMonthInGanZhi()}：',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          calcShenSha(StemsBranchItem(
                            stems: Stems.getStemsByLabel(
                                selectedLiuYue.getLunar().getMonthGan()),
                            branch: Branches.getBranchByLabel(
                                selectedLiuYue.getLunar().getMonthZhi()),
                          )),
                          style: TextStyle(
                            color: const Color(0xff393b41),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.w),

            /// 流日神煞
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
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '流日神煞',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedLiuRi.getLunar().getDayInGanZhi()}：',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          calcShenSha(StemsBranchItem(
                            stems: Stems.getStemsByLabel(
                                selectedLiuRi.getLunar().getDayGan()),
                            branch: Branches.getBranchByLabel(
                                selectedLiuRi.getLunar().getZhi()),
                          )),
                          style: TextStyle(
                            color: const Color(0xff393b41),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
