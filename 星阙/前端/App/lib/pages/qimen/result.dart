import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluwx/fluwx.dart';
import 'package:horosa/services/qi_men.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:horosa/constants/xing_nian.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/constants/shen_sha.dart';
import 'package:horosa/models/bazi.dart';
import 'package:horosa/models/gender.dart';
import 'package:horosa/models/horosa.dart';
import 'package:horosa/models/picker.dart';
import 'package:horosa/models/qi_men.dart';
import 'package:horosa/pages/qimen/widgets/dialog_button.dart';
import 'package:horosa/pages/qimen/widgets/move_star.dart';
import 'package:horosa/pages/qimen/widgets/time_flow.dart';
import 'package:horosa/services/archive.dart';
import 'package:horosa/utils/cyclic_sort.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/utils/log.dart';
import 'package:horosa/utils/toast.dart';
import 'package:horosa/widgets/relation_dialog_button.dart';
import 'package:horosa/widgets/five_phases_growth.dart';
import 'package:horosa/widgets/forms/forms.dart';
import 'package:horosa/widgets/non_bazi_shensha.dart';
import 'package:horosa/widgets/single_picker.dart';
import 'package:lunar/lunar.dart';
import 'package:screenshot/screenshot.dart';
import 'widgets/result_app_bar.dart';

/// 空亡
class Kong {
  final String label;
  final int value;
  final String xunKong;

  const Kong({required this.label, required this.value, required this.xunKong});
}

/// 驿马
class YiMa {
  final String label;
  final int value;
  final String branch;

  const YiMa({required this.label, required this.value, required this.branch});
}

class QiMenResultPage extends StatefulWidget {
  static const String route = '/qimen/result';

  const QiMenResultPage({super.key});

  @override
  State<QiMenResultPage> createState() => _QiMenResultPageState();
}

class _QiMenResultPageState extends State<QiMenResultPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  late TextEditingController controller;
  late QiMenInput input;
  late QiMenResult result;
  late QiMenExtras extras;
  late List<YiMa> yimaList = [];
  late List<Kong> kongList = [];
  late ArchiveItem item;
  late Kong kong;
  late YiMa ma;
  late int year;
  late int month;
  late int day;
  late int hour;
  late int minute;
  late Lunar lunar;
  late EightChar eightChar;
  String datetime = '';
  int? seal = 0;
  Gender? gender; // 卦主性别
  String? zodiac; // 卦主生肖
  String xingNian = '';

  bool locked = false; // 时间切换锁定

  WeChatScene scene = WeChatScene.session;
  WeChatImage? source;
  WeChatImage? thumbnail;
  Fluwx fluwx = Fluwx();

  void _shareImage() async {
    if (LocalMode.enabled) {
      toast('桌面版暂不支持微信分享，请先保存图片');
      return;
    }
    if (source == null) {
      return;
    }
    if (mounted) {
      Navigator.pop(context);
    }
    try {
      await fluwx.share(
          WeChatShareImageModel(source!, thumbnail: thumbnail, scene: scene));
    } catch (_) {
      toast('微信分享不可用，请先保存图片');
    }
  }

  Future<void> saveImageToGallery(Uint8List bytes) async {
    final result = await ImageGallerySaver.saveImage(bytes,
        quality: 100, name: "screenshot");
    if (result['isSuccess'] == true) {
      toast('保存成功~');
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  String dateTimeFormat(int year, int month, int day, int hour, int minute) {
    return '$year年${month.toString().padLeft(2, '0')}月${day.toString().padLeft(2, '0')}日 ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String getShenShaBranch(Map<String, Map<String, List<String>>> shenShaMap,
      String shenSha, String sob) {
    List<String>? branch = shenShaMap[shenSha]?[sob];
    if (branch != null) {
      return branch.join('');
    }
    return '';
  }

  String clacXingNian() {
    String result = '';
    if (gender == null || zodiac == null) {
      return result;
    }
    String yearBranch = eightChar.getYearZhi();
    int index = branchChars.indexWhere((b) => zodiac2BranchMap[zodiac] == b);
    List<String> branches = cyclicSort(branchChars, index, branchChars.length);
    index = branches.indexWhere((b) => b == yearBranch);
    if (gender == Gender.male) {
      result = maleXingNianBase[index];
    } else {
      result = femaleXingNianBase[index];
    }

    return result;
  }

  Future<void> updateQiMenResult() async {
    QiMenSvc.getQiMenResult(input).then((res) {
      setState(() {
        locked = false;
      });
      if (res.statusCode == 200) {
        if (res.data['code'] == 0) {
          result = QiMenResult.fromJson(res.data['data']);
        }
      }
    });
  }

  void handler() {
    kongList = [
      Kong(label: '日空', value: 1, xunKong: eightChar.getDayXunKong()),
      Kong(label: '时空', value: 2, xunKong: eightChar.getTimeXunKong()),
    ];
    kong = kongList[kong.value - 1];
    yimaList = [
      YiMa(label: '日马', value: 1, branch: eightChar.getDayZhi()),
      YiMa(label: '时马', value: 2, branch: eightChar.getTimeZhi()),
    ];
    ma = yimaList[ma.value - 1];
  }

  void initial() {
    kongList = [
      Kong(label: '日空', value: 1, xunKong: eightChar.getDayXunKong()),
      Kong(label: '时空', value: 2, xunKong: eightChar.getTimeXunKong()),
    ];
    kong = kongList[0];
    yimaList = [
      YiMa(label: '日马', value: 1, branch: eightChar.getDayZhi()),
      YiMa(label: '时马', value: 2, branch: eightChar.getTimeZhi()),
    ];
    ma = yimaList[0];
  }

  void update() {
    Solar solar = lunar.getSolar();
    input.guaTime = QiMenGuaTime(
      year: solar.getYear(),
      month: solar.getMonth(),
      day: solar.getDay(),
      hour: solar.getHour(),
      minute: solar.getMinute(),
    );
    year = input.guaTime.year;
    month = input.guaTime.month;
    day = input.guaTime.day;
    hour = input.guaTime.hour;
    minute = input.guaTime.minute;
    datetime = dateTimeFormat(year, month, day, hour, minute);
    locked = true;
    updateQiMenResult();
    handler();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final args = ModalRoute.of(context)!.settings.arguments as ArchiveItem;
        item = args.toQiMen();
        input = item.input;
        result = item.output;
        extras = item.extras;
        year = input.guaTime.year;
        month = input.guaTime.month;
        day = input.guaTime.day;
        hour = input.guaTime.hour;
        minute = input.guaTime.minute;
        datetime = dateTimeFormat(year, month, day, hour, minute);
        lunar = Solar.fromYmdHms(year, month, day, hour, minute, 0).getLunar();
        eightChar = lunar.getEightChar();
        eightChar.setSect(1);
        gender = Gender.getByValue(extras.gender);
        zodiac = extras.zodiac;
        xingNian = clacXingNian();
        seal = extras.seal ?? 0;
        initial();
        controller = TextEditingController(text: input.question ?? '');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfffbfbfb),
          surfaceTintColor: const Color(0xfffbfbfb),
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/arrow-left.svg',
              width: 17.w,
              height: 32.w,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: QiMenResultAppBar(
            input: input,
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                final image = await screenshotController.capture();
                if (!context.mounted) return;
                if (image != null) {
                  source = WeChatImage.binary(image);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    builder: (context) => BottomSheet(
                      onClosing: () {},
                      showDragHandle: false,
                      enableDrag: false,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 140.w, vertical: 80.w),
                            child: Image.memory(
                              image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            width: 1.sw,
                            height: 376.w,
                            decoration: ShapeDecoration(
                              color: const Color(0xffffffff),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(72.r),
                                  topRight: Radius.circular(72.r),
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await saveImageToGallery(image);
                                      },
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/ic-download.svg',
                                            width: 84.w,
                                            height: 84.w,
                                          ),
                                          Text(
                                            '保存图片',
                                            style: TextStyle(
                                              color: const Color(0xff454545),
                                              fontSize: 30.sp,
                                              fontFamily: 'PingFang SC',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          scene = WeChatScene.session;
                                        });
                                        _shareImage();
                                      },
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/ic-wechat.svg',
                                            width: 84.w,
                                            height: 84.w,
                                          ),
                                          Text(
                                            '微信',
                                            style: TextStyle(
                                              color: const Color(0xff454545),
                                              fontSize: 30.sp,
                                              fontFamily: 'PingFang SC',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          scene = WeChatScene.timeline;
                                        });
                                        _shareImage();
                                      },
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/ic-moments.svg',
                                            width: 84.w,
                                            height: 84.w,
                                          ),
                                          Text(
                                            '朋友圈',
                                            style: TextStyle(
                                              color: const Color(0xff454545),
                                              fontSize: 30.sp,
                                              fontFamily: 'PingFang SC',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 40.w),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 654.w,
                                    height: 86.w,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xff222426),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(43.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '取消',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xfff8cc76),
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
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
                } else {
                  toast('截图失败');
                }
              },
              child: SvgPicture.asset(
                'assets/icons/share.svg',
                width: 34.w,
                height: 36.w,
              ),
            ),
            SizedBox(width: 36.w)
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            datetime,
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            child: Row(
                              children: [
                                Text(
                                  '奇门封局',
                                  style: TextStyle(
                                    color: const Color(0xfff8cc76),
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                HorosaSwitch(
                                  color: const Color(0xfff8cc76),
                                  value: seal == 1,
                                  onChange: (value) {
                                    setState(() {
                                      seal = value ? 1 : 0;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 30.w,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: Stems.getStemsByLabel(
                                                eightChar.getYearGan())
                                            .label,
                                        style: TextStyle(
                                          color: Stems.getStemsByLabel(
                                                  eightChar.getYearGan())
                                              .element
                                              .color,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: Branches.getBranchByLabel(
                                                eightChar.getYearZhi())
                                            .label,
                                        style: TextStyle(
                                          color: Branches.getBranchByLabel(
                                                  eightChar.getYearZhi())
                                              .element
                                              .color,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '年',
                                style: TextStyle(
                                  color: const Color(0xff88898d),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              SizedBox(
                                width: 30.w,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: Stems.getStemsByLabel(
                                                eightChar.getMonthGan())
                                            .label,
                                        style: TextStyle(
                                          color: Stems.getStemsByLabel(
                                                  eightChar.getMonthGan())
                                              .element
                                              .color,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: Branches.getBranchByLabel(
                                                eightChar.getMonthZhi())
                                            .label,
                                        style: TextStyle(
                                          color: Branches.getBranchByLabel(
                                                  eightChar.getMonthZhi())
                                              .element
                                              .color,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '月',
                                style: TextStyle(
                                  color: const Color(0xff88898d),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              SizedBox(
                                width: 30.w,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: Stems.getStemsByLabel(
                                                eightChar.getDayGan())
                                            .label,
                                        style: TextStyle(
                                          color: Stems.getStemsByLabel(
                                                  eightChar.getDayGan())
                                              .element
                                              .color,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: Branches.getBranchByLabel(
                                                eightChar.getDayZhi())
                                            .label,
                                        style: TextStyle(
                                          color: Branches.getBranchByLabel(
                                                  eightChar.getDayZhi())
                                              .element
                                              .color,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '日',
                                style: TextStyle(
                                  color: const Color(0xff88898d),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              SizedBox(
                                width: 30.w,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: Stems.getStemsByLabel(
                                                eightChar.getTimeGan())
                                            .label,
                                        style: TextStyle(
                                          color: Stems.getStemsByLabel(
                                                  eightChar.getTimeGan())
                                              .element
                                              .color,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: Branches.getBranchByLabel(
                                                eightChar.getTimeZhi())
                                            .label,
                                        style: TextStyle(
                                          color: Branches.getBranchByLabel(
                                                  eightChar.getTimeZhi())
                                              .element
                                              .color,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '时',
                                style: TextStyle(
                                  color: const Color(0xff88898d),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Text.rich(
                            textAlign: TextAlign.end,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${kong.label}-',
                                  style: TextStyle(
                                    color: const Color(0xff222426),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: kong.xunKong,
                                  style: TextStyle(
                                    color: const Color(0xff88898d),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(text: '\n'),
                                TextSpan(
                                  text: '旬首-',
                                  style: TextStyle(
                                    color: const Color(0xff222426),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: eightChar.getDayXun(),
                                  style: TextStyle(
                                    color: const Color(0xff88898d),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${result.paiju.substring(0, 4)} 值符:${result.zhifushi.xing} 值使:${result.zhifushi.shi}',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Visibility(
                            visible: seal != 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      if (locked) return;
                                      setState(() {
                                        lunar = lunar
                                            .getSolar()
                                            .prevHour(2)
                                            .getLunar();
                                        eightChar = EightChar.fromLunar(lunar);
                                        eightChar.setSect(1);
                                        update();
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
                                      if (locked) return;
                                      setState(() {
                                        lunar = lunar
                                            .getSolar()
                                            .nextHour(2)
                                            .getLunar();
                                        eightChar = EightChar.fromLunar(lunar);
                                        eightChar.setSect(1);
                                        update();
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow-right-frame.svg',
                                      width: 40.w,
                                      height: 40.w,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.w),
                      Divider(height: 1.w, color: const Color(0xfff2f2f2)),
                      SizedBox(height: 20.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text.rich(
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
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
                                        ShenShaUtil.OTHER_DAY_STEMS,
                                        '日禄',
                                        eightChar.getDayGan()),
                                    style: TextStyle(
                                      color: const Color(0x99393b41),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  日德-',
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: getShenShaBranch(
                                        ShenShaUtil.OTHER_DAY_STEMS,
                                        '日德',
                                        eightChar.getDayGan()),
                                    style: TextStyle(
                                      color: const Color(0x99393b41),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  天马-',
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: getShenShaBranch(
                                        ShenShaUtil.OTHER_MONTH_BRANCH,
                                        '天马',
                                        eightChar.getMonthZhi()),
                                    style: TextStyle(
                                      color: const Color(0xff85878b),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  日马-',
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: getShenShaBranch(
                                        ShenShaUtil.OTHER_DAY_BRANCH,
                                        '日马',
                                        eightChar.getDayZhi()),
                                    style: TextStyle(
                                      color: const Color(0xff85878b),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  年马-',
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: getShenShaBranch(
                                        ShenShaUtil.OTHER_YEAR_BRANCH,
                                        '年马',
                                        eightChar.getYearZhi()),
                                    style: TextStyle(
                                      color: const Color(0xff85878b),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                      contentPadding: EdgeInsets.zero,
                                      children: [
                                        Container(
                                          width: 1.sw - 72.w,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30.w, vertical: 30.w),
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(36.r),
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
                                                      color: const Color(
                                                          0xff222426),
                                                      fontSize: 30.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: 1.sw,
                                                  padding: EdgeInsets.only(
                                                      top: 64.w),
                                                  child: NonBaziShensha(
                                                      lunar: lunar),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]);
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  '查看更多',
                                  style: TextStyle(
                                    color: const Color(0xfff8cc76),
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                SvgPicture.asset('assets/icons/arrow-right.svg',
                                    width: 7.w, height: 14.w),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.w),
                Stack(
                  children: [
                    Table(
                      border:
                          TableBorder.all(color: Colors.transparent, width: 1),
                      columnWidths: {
                        1: FixedColumnWidth(8.w),
                        3: FixedColumnWidth(8.w),
                      },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                height: 214.w,
                                margin: EdgeInsets.only(bottom: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(36.r),
                                      topRight: Radius.circular(22.r),
                                      bottomLeft: Radius.circular(22.r),
                                      bottomRight: Radius.circular(22.r),
                                    ),
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
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: '辰巳'.contains(ShenShaUtil
                                          .OTHER_DAY_BRANCH['日马']![ma.branch]!
                                          .join('')),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.w, right: 16.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/horse.svg',
                                            width: 26.w,
                                            height: 20.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.tianpan['1'] ?? '',
                                              style: TextStyle(
                                                color: '壬癸'.contains(
                                                        result.tianpan['1']!)
                                                    ? const Color(0xffc0281c)
                                                    : '辛壬'.contains(result
                                                            .tianpan['1']!)
                                                        ? const Color(
                                                            0xff945b3c)
                                                        : const Color(
                                                            0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.shen['1']!,
                                              style: TextStyle(
                                                color: '虎' == result.shen['1']!
                                                    ? const Color(0xfff1ac62)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        result.men['1']!.substring(0, 1),
                                        style: TextStyle(
                                          color: '开惊'.contains(result.men['1']!
                                                  .substring(0, 1))
                                              ? const Color(0xffff6f00)
                                              : const Color(0xff222426),
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.dipan['1'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.xing['1'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        '巽',
                                        style: TextStyle(
                                          color: (kong.xunKong.contains('辰') ||
                                                  kong.xunKong.contains('巳'))
                                              ? const Color(0xff3371ca)
                                              : const Color(0xffcccccc),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const TableCell(child: SizedBox()),
                            TableCell(
                              child: Container(
                                height: 214.w,
                                margin: EdgeInsets.only(bottom: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22.r),
                                      topRight: Radius.circular(22.r),
                                      bottomLeft: Radius.circular(22.r),
                                      bottomRight: Radius.circular(22.r),
                                    ),
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
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: '午' ==
                                          ShenShaUtil.OTHER_DAY_BRANCH['日马']![
                                                  ma.branch]!
                                              .join(''),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.w, right: 16.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/horse.svg',
                                            width: 26.w,
                                            height: 20.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.tianpan['2'] ?? '',
                                              style: TextStyle(
                                                color: '辛' ==
                                                        result.tianpan['2']!
                                                    ? const Color(0xffc0281c)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.shen['2']!,
                                              style: TextStyle(
                                                color: '虎' == result.shen['2']!
                                                    ? const Color(0xfff1ac62)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        result.men['2']!.substring(0, 1),
                                        style: TextStyle(
                                          color: result.men['2']!
                                                      .substring(0, 1) ==
                                                  '休'
                                              ? const Color(0xffff6f00)
                                              : const Color(0xff222426),
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.dipan['2'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.xing['2'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        '离',
                                        style: TextStyle(
                                          color: kong.xunKong.contains('午')
                                              ? const Color(0xff3371ca)
                                              : const Color(0xffcccccc),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const TableCell(child: SizedBox()),
                            TableCell(
                              child: Container(
                                height: 214.w,
                                margin: EdgeInsets.only(bottom: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22.r),
                                      topRight: Radius.circular(36.r),
                                      bottomLeft: Radius.circular(22.r),
                                      bottomRight: Radius.circular(22.r),
                                    ),
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
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: '未申'.contains(ShenShaUtil
                                          .OTHER_DAY_BRANCH['日马']![ma.branch]!
                                          .join('')),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.w, right: 16.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/horse.svg',
                                            width: 26.w,
                                            height: 20.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.tianpan['3'] ?? '',
                                              style: TextStyle(
                                                color: '己' ==
                                                        result.tianpan['3']!
                                                    ? const Color(0xffc0281c)
                                                    : '甲癸'.contains(result
                                                            .tianpan['3']!)
                                                        ? const Color(
                                                            0xff945b3c)
                                                        : const Color(
                                                            0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.shen['3']!,
                                              style: TextStyle(
                                                color: '虎' == result.shen['3']!
                                                    ? const Color(0xfff1ac62)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        result.men['3']!.substring(0, 1),
                                        style: TextStyle(
                                          color: '伤杜'.contains(result.men['3']!
                                                  .substring(0, 1))
                                              ? const Color(0xffff6f00)
                                              : const Color(0xff222426),
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.dipan['3'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.xing['3'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        '坤',
                                        style: TextStyle(
                                          color: (kong.xunKong.contains('未') ||
                                                  kong.xunKong.contains('申'))
                                              ? const Color(0xff3371ca)
                                              : const Color(0xffcccccc),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                height: 214.w,
                                margin: EdgeInsets.only(bottom: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22.r),
                                      topRight: Radius.circular(22.r),
                                      bottomLeft: Radius.circular(22.r),
                                      bottomRight: Radius.circular(22.r),
                                    ),
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
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: '卯' ==
                                          ShenShaUtil.OTHER_DAY_BRANCH['日马']![
                                                  ma.branch]!
                                              .join(''),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.w, right: 16.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/horse.svg',
                                            width: 26.w,
                                            height: 20.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.tianpan['4'] ?? '',
                                              style: TextStyle(
                                                color: '戊' ==
                                                        result.tianpan['4']!
                                                    ? const Color(0xffc0281c)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.shen['4']!,
                                              style: TextStyle(
                                                color: '虎' == result.shen['4']!
                                                    ? const Color(0xfff1ac62)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        result.men['4']!.substring(0, 1),
                                        style: TextStyle(
                                          color: '开惊'.contains(result.men['4']!
                                                  .substring(0, 1))
                                              ? const Color(0xffff6f00)
                                              : const Color(0xff222426),
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.dipan['4'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.xing['4'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '震',
                                        style: TextStyle(
                                          color: kong.xunKong.contains('卯')
                                              ? const Color(0xff3371ca)
                                              : const Color(0xffcccccc),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const TableCell(child: SizedBox()),
                            TableCell(
                              child: Container(
                                height: 214.w,
                                margin: EdgeInsets.only(bottom: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22.r),
                                      topRight: Radius.circular(22.r),
                                      bottomLeft: Radius.circular(22.r),
                                      bottomRight: Radius.circular(22.r),
                                    ),
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
                                child: Center(
                                  child: Text(
                                    result.dipan['5'] ?? '',
                                    style: TextStyle(
                                      color: const Color(0xffcccccc),
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const TableCell(child: SizedBox()),
                            TableCell(
                              child: Container(
                                height: 214.w,
                                margin: EdgeInsets.only(bottom: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22.r),
                                      topRight: Radius.circular(22.r),
                                      bottomLeft: Radius.circular(22.r),
                                      bottomRight: Radius.circular(22.r),
                                    ),
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
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: '酉' ==
                                          ShenShaUtil.OTHER_DAY_BRANCH['日马']![
                                                  ma.branch]!
                                              .join(''),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.w, right: 16.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/horse.svg',
                                            width: 26.w,
                                            height: 20.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.tianpan['6'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.shen['6']!,
                                              style: TextStyle(
                                                color: '虎' == result.shen['6']!
                                                    ? const Color(0xfff1ac62)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        result.men['6']!.substring(0, 1),
                                        style: TextStyle(
                                          color: '景' ==
                                                  result.men['6']!
                                                      .substring(0, 1)
                                              ? const Color(0xffff6f00)
                                              : const Color(0xff222426),
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.dipan['6']!
                                                  .substring(0, 1),
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.xing['6'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '兑',
                                        style: TextStyle(
                                          color: kong.xunKong.contains('酉')
                                              ? const Color(0xff3371ca)
                                              : const Color(0xffcccccc),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                height: 214.w,
                                margin: EdgeInsets.only(bottom: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(36.r),
                                      topRight: Radius.circular(22.r),
                                      bottomLeft: Radius.circular(22.r),
                                      bottomRight: Radius.circular(22.r),
                                    ),
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
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: '寅丑'.contains(ShenShaUtil
                                          .OTHER_DAY_BRANCH['日马']![ma.branch]!
                                          .join('')),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 16.w, left: 16.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/horse.svg',
                                            width: 26.w,
                                            height: 20.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.tianpan['7'] ?? '',
                                              style: TextStyle(
                                                color: '庚' ==
                                                        result.tianpan['7']!
                                                    ? const Color(0xffc0281c)
                                                    : '丁己庚'.contains(result
                                                            .tianpan['7']!)
                                                        ? const Color(
                                                            0xff945b3c)
                                                        : const Color(
                                                            0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.shen['7']!,
                                              style: TextStyle(
                                                color: '虎' == result.shen['7']!
                                                    ? const Color(0xfff1ac62)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        result.men['7']!.substring(0, 1),
                                        style: TextStyle(
                                          color: '伤杜'.contains(result.men['7']!
                                                  .substring(0, 1))
                                              ? const Color(0xffff6f00)
                                              : const Color(0xff222426),
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.dipan['7']!,
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.xing['7'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        '艮',
                                        style: TextStyle(
                                          color: (kong.xunKong.contains('丑') ||
                                                  kong.xunKong.contains('寅'))
                                              ? const Color(0xff3371ca)
                                              : const Color(0xffcccccc),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const TableCell(child: SizedBox()),
                            TableCell(
                              child: Container(
                                height: 214.w,
                                margin: EdgeInsets.only(bottom: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22.r),
                                      topRight: Radius.circular(22.r),
                                      bottomLeft: Radius.circular(22.r),
                                      bottomRight: Radius.circular(22.r),
                                    ),
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
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: '子' ==
                                          ShenShaUtil.OTHER_DAY_BRANCH['日马']![
                                                  ma.branch]!
                                              .join(''),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.w, right: 16.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/horse.svg',
                                            width: 26.w,
                                            height: 20.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.tianpan['8'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.shen['8']!,
                                              style: TextStyle(
                                                color: '虎' == result.shen['8']!
                                                    ? const Color(0xfff1ac62)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        result.men['8']!.substring(0, 1),
                                        style: TextStyle(
                                          color: '生死'.contains(result.men['8']!
                                                  .substring(0, 1))
                                              ? const Color(0xffff6f00)
                                              : const Color(0xff222426),
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.dipan['8']!,
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.xing['8'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        '坎',
                                        style: TextStyle(
                                          color: kong.xunKong.contains('子')
                                              ? const Color(0xff3371ca)
                                              : const Color(0xffcccccc),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const TableCell(child: SizedBox()),
                            TableCell(
                              child: Container(
                                height: 214.w,
                                margin: EdgeInsets.only(bottom: 8.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22.r),
                                      topRight: Radius.circular(36.r),
                                      bottomLeft: Radius.circular(22.r),
                                      bottomRight: Radius.circular(22.r),
                                    ),
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
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: '戌亥'.contains(ShenShaUtil
                                          .OTHER_DAY_BRANCH['日马']![ma.branch]!
                                          .join('')),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.w, right: 16.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/horse.svg',
                                            width: 26.w,
                                            height: 20.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.tianpan['9'] ?? '',
                                              style: TextStyle(
                                                color: '乙丙戊'.contains(
                                                        result.tianpan['9']!)
                                                    ? const Color(0xff945b3c)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.shen['9']!,
                                              style: TextStyle(
                                                color: '虎' == result.shen['9']!
                                                    ? const Color(0xfff1ac62)
                                                    : const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        result.men['9']!.substring(0, 1),
                                        style: TextStyle(
                                          color: '景' ==
                                                  result.men['9']!
                                                      .substring(0, 1)
                                              ? const Color(0xffff6f00)
                                              : const Color(0xff222426),
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 32.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              result.dipan['9']!,
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              result.xing['9'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff393b41),
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        '乾',
                                        style: TextStyle(
                                          color: (kong.xunKong.contains('戌') ||
                                                  kong.xunKong.contains('亥'))
                                              ? const Color(0xff3371ca)
                                              : const Color(0xffcccccc),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                      visible: seal == 1,
                      child: Positioned.fill(
                        child: Opacity(
                          opacity: 0.25,
                          child: Image.asset('assets/images/sealed.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.w),
                          width: 24.w,
                          height: 24.w,
                          color: const Color(0xffc0281c),
                        ),
                        Text('击刑',
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.w900))
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.w),
                          width: 24.w,
                          height: 24.w,
                          color: const Color(0xff945b3c),
                        ),
                        Text('入墓',
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.w900))
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.w),
                          width: 24.w,
                          height: 24.w,
                          color: const Color(0xffff6f00),
                        ),
                        Text('门迫',
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.w900))
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.w),
                          width: 24.w,
                          height: 24.w,
                          color: const Color(0xff3371ca),
                        ),
                        Text('空亡',
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.w900))
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8.w),
                          width: 30.w,
                          height: 22.w,
                          child: SvgPicture.asset(
                            'assets/svgs/horse.svg',
                            width: 30.w,
                            height: 22.w,
                          ),
                        ),
                        Text('驿马',
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.w900))
                      ],
                    )
                  ],
                ),
                SizedBox(height: 30.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
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
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 24.w),
                        width: 1.sw,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xffe5e5e5),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '行       年：',
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    SinglePicker(
                                      options: Gender.values,
                                      height: 560.w,
                                      value: gender?.value ?? Gender.male.value,
                                      mapper: (option) => PickerItem(
                                        label: option.alias,
                                        value: option.value,
                                      ),
                                      onChange: (value) {
                                        setState(() {
                                          gender = value;
                                          extras.gender = value.value;
                                          xingNian = clacXingNian();
                                        });
                                      },
                                    ).show(context);
                                  },
                                  child: Text(
                                    gender?.alias ?? '请选择性别',
                                    style: TextStyle(
                                      color: gender == null
                                          ? const Color(0x99393b41)
                                          : const Color(0xff222426),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: SvgPicture.asset(
                                    'assets/icons/arrow-down-fill.svg',
                                    width: 24.w,
                                    height: 24.w,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 24.w),
                            Visibility(
                              visible: gender != null,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SinglePicker(
                                        value: zodiac ?? '鼠',
                                        options: LunarUtil.SHENGXIAO
                                            .where(
                                                (element) => element.isNotEmpty)
                                            .map((element) => PickerItem(
                                                label: element, value: element))
                                            .toList(),
                                        mapper: (option) => PickerItem(
                                            label: option.label,
                                            value: option.value),
                                        onChange: (item) {
                                          setState(() {
                                            zodiac = item.value;
                                            extras.zodiac = zodiac;
                                            xingNian = clacXingNian();
                                          });
                                        },
                                      ).show(context);
                                    },
                                    child: Text(
                                      zodiac != null ? '生肖:$zodiac' : '请选择生肖',
                                      style: TextStyle(
                                        color: zodiac != null
                                            ? const Color(0xff222426)
                                            : const Color(0x99393b41),
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.w),
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow-down-fill.svg',
                                      width: 24.w,
                                      height: 24.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 24.w),
                            Visibility(
                              visible: zodiac != null,
                              child: Text(
                                xingNian,
                                style: TextStyle(
                                  color: const Color(0xff88898d),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.w),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20.w),
                        width: 1.sw,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xffe5e5e5),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          height: 43.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '占       问：',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '所问之事',
                                    hintStyle: TextStyle(
                                      color: const Color(0x99393b41),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w700,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.w),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20.w),
                        width: 1.sw,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xffe5e5e5),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            HorosaRadio(
                              value: kongList[0],
                              label: kongList[0].label,
                              checked: kongList[0] == kong,
                              onChange: (val) {
                                setState(() {
                                  kong = val;
                                });
                              },
                            ),
                            HorosaRadio(
                              value: kongList[1],
                              label: kongList[1].label,
                              checked: kongList[1] == kong,
                              onChange: (val) {
                                setState(() {
                                  kong = val;
                                });
                              },
                            ),
                            HorosaRadio(
                              value: yimaList[0],
                              label: yimaList[0].label,
                              checked: yimaList[0] == ma,
                              onChange: (val) {
                                setState(() {
                                  ma = val;
                                });
                              },
                            ),
                            HorosaRadio(
                              value: yimaList[1],
                              label: yimaList[1].label,
                              checked: yimaList[1] == ma,
                              onChange: (val) {
                                setState(() {
                                  ma = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.w),
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 18.w,
                        children: [
                          DialogButton(
                            label: '时间流',
                            child: TimeFlow(lunar: lunar),
                          ),
                          const RelationDialogButton(label: '天干寄宫'),
                          const RelationDialogButton(label: '三合'),
                          const RelationDialogButton(label: '刑'),
                          const RelationDialogButton(label: '害'),
                          const RelationDialogButton(label: '破'),
                          const RelationDialogButton(label: '六合'),
                          const FivePhasesGrowth(),
                          DialogButton(
                            label: '移星',
                            child: MoveStar(
                              lunar: lunar,
                              result: result,
                              branch: ma.branch,
                              kong: kong.xunKong,
                              seal: seal,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.w),
                GestureDetector(
                  onTap: () async {
                    extras.seal = seal;
                    input.question = controller.text;
                    try {
                      final res = await ArchiveSvc.record(item);
                      if (res.statusCode == 200) {
                        Log.d(res.data);
                        if (res.data['code'] == 0) {
                          toast('保存成功~');
                        } else {
                          toast(res.data['msg']);
                        }
                      }
                    } catch (_) {
                      toast('保存失败，请稍后重试');
                    }
                  },
                  child: Container(
                    height: 86.w,
                    decoration: ShapeDecoration(
                      color: const Color(0xff222426),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(42.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '保存',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xfff8cc76),
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
