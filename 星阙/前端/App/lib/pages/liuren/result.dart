import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluwx/fluwx.dart';
import 'package:horosa/utils/cyclic_sort.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:horosa/constants/shen_sha.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/gender.dart';
import 'package:horosa/models/horosa.dart';
import 'package:horosa/models/liu_ren.dart';
import 'package:horosa/models/picker.dart';
import 'package:horosa/services/archive.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/utils/log.dart';
import 'package:horosa/utils/toast.dart';
import 'package:horosa/constants/xing_nian.dart';
import 'package:horosa/widgets/relation_dialog_button.dart';
import 'package:horosa/widgets/five_phases_growth.dart';
import 'package:horosa/widgets/non_bazi_shensha.dart';
import 'package:horosa/widgets/single_picker.dart';
import 'package:lunar/lunar.dart';
import 'widgets/result_app_bar.dart';

/// 六壬
class LiuRenResultPage extends StatefulWidget {
  static const String route = '/liuren/result';

  const LiuRenResultPage({super.key});

  @override
  State<LiuRenResultPage> createState() => _LiuRenResultPageState();
}

class _LiuRenResultPageState extends State<LiuRenResultPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  late TextEditingController controller;
  Gender? gender; // 卦主性别
  String? zodiac; // 卦主生肖
  String xingNian = '';
  late ArchiveItem item;
  late LiuRenInput input;
  late LiuRenResult result;
  late LiuRenExtras extras;

  late int year;
  late int month;
  late int day;
  late int hour;
  late int minute;

  late Lunar lunar;

  late EightChar eightChar;

  late Map<String, String> tianpan;
  late Map<String, String> tiangan;
  late Map<String, String> tinajiang;

  late String xunKong;

  WeChatScene scene = WeChatScene.session;
  WeChatImage? source;
  WeChatImage? thumbnail;
  Fluwx fluwx = Fluwx();

  bool loading = true;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final args = ModalRoute.of(context)!.settings.arguments as ArchiveItem;
        item = args.toLiuRen();
        input = item.input;
        result = item.output;
        extras = item.extras;

        year = input.guaTime.year;
        month = input.guaTime.month;
        day = input.guaTime.day;
        hour = input.guaTime.hour;
        minute = input.guaTime.minute;

        tianpan = result.tianpan; // 天盘
        tiangan = result.tiangan; // 天干
        tinajiang = result.tianjiang; // 天将
        lunar = Solar.fromYmdHms(year, month, day, hour, minute, 0).getLunar();
        eightChar = lunar.getEightChar();
        eightChar.setSect(1);
        gender = Gender.getByValue(extras.gender);
        zodiac = extras.zodiac;
        xingNian = clacXingNian();

        xunKong = eightChar.getDayXunKong();

        controller = TextEditingController(text: input.question ?? '');

        loading = false;
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
    return loading
        ? const Center(child: CircularProgressIndicator())
        : Screenshot(
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
                title: LiuRenResultAppBar(
                  input: input,
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      final image = await screenshotController
                          .capture(); // Capture the Scaffold screenshot
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                    color:
                                                        const Color(0xff454545),
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
                                                    color:
                                                        const Color(0xff454545),
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
                                                    color:
                                                        const Color(0xff454545),
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
                    icon: SvgPicture.asset(
                      'assets/icons/share.svg',
                      width: 34.w,
                      height: 36.w,
                    ),
                  ),
                  SizedBox(width: 12.w)
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36.w),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 30.w),
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
                                  dateTimeFormat(
                                      year, month, day, hour, minute),
                                  style: TextStyle(
                                    color: const Color(0xff222426),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text.rich(
                                  textAlign: TextAlign.right,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '月将',
                                        style: TextStyle(
                                          color: const Color(0xff222426),
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '-${result.yuejiang}',
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
                                                color:
                                                    Branches.getBranchByLabel(
                                                            eightChar
                                                                .getYearZhi())
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
                                                color:
                                                    Branches.getBranchByLabel(
                                                            eightChar
                                                                .getMonthZhi())
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
                                                color:
                                                    Branches.getBranchByLabel(
                                                            eightChar
                                                                .getDayZhi())
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
                                                color:
                                                    Branches.getBranchByLabel(
                                                            eightChar
                                                                .getTimeZhi())
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
                                        text: '旬空-',
                                        style: TextStyle(
                                          color: const Color(0xff222426),
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: eightChar.getDayXunKong(),
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
                            SizedBox(height: 20.w),
                            Divider(
                                height: 1.w, color: const Color(0xfff2f2f2)),
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
                                                    horizontal: 30.w,
                                                    vertical: 30.w),
                                                decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            36.r),
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        width: 1.sw,
                                                        padding:
                                                            EdgeInsets.only(
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
                                      SvgPicture.asset(
                                          'assets/icons/arrow-right.svg',
                                          width: 7.w,
                                          height: 14.w),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 30.w),
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
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Top Text
                                  Text(
                                    '${tinajiang['巳']}${tinajiang['午']}${tinajiang['未']}${tinajiang['申']}',
                                    style: TextStyle(
                                      color: const Color(0xfff1ac62),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.w,
                                    ),
                                  ),
                                  SizedBox(height: 8.w),
                                  // Second Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TimeStemsPlainText(
                                        xunKong: xunKong,
                                        branch: tianpan['巳']!,
                                        stems: tiangan['巳']!,
                                      ),
                                      TimeStemsPlainText(
                                        xunKong: xunKong,
                                        branch: tianpan['午']!,
                                        stems: tiangan['午']!,
                                      ),
                                      TimeStemsPlainText(
                                        xunKong: xunKong,
                                        branch: tianpan['未']!,
                                        stems: tiangan['未']!,
                                      ),
                                      TimeStemsPlainText(
                                        xunKong: xunKong,
                                        branch: tianpan['申']!,
                                        stems: tiangan['申']!,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.w),
                                  // Middle Section
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            tinajiang['辰']!,
                                            style: TextStyle(
                                              color: const Color(0xfff1ac62),
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(height: 8.w),
                                          Text(
                                            tinajiang['卯']!,
                                            style: TextStyle(
                                              color: const Color(0xfff1ac62),
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        children: [
                                          TimeStemsPlainText(
                                            xunKong: xunKong,
                                            branch: tianpan['辰']!,
                                            stems: tiangan['辰']!,
                                          ),
                                          SizedBox(height: 8.w),
                                          TimeStemsPlainText(
                                            xunKong: xunKong,
                                            branch: tianpan['卯']!,
                                            stems: tiangan['卯']!,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                tianpan['巳']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                              Text(
                                                tianpan['午']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                              Text(
                                                tianpan['未']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                              Text(
                                                tianpan['申']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.w),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                tianpan['辰']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                              SizedBox(width: 36.w),
                                              SizedBox(width: 36.w),
                                              Text(
                                                tianpan['酉']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.w),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                tianpan['卯']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                              SizedBox(width: 36.w),
                                              SizedBox(width: 36.w),
                                              Text(
                                                tianpan['戌']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.w),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                tianpan['寅']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                              Text(
                                                tianpan['丑']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                              Text(
                                                tianpan['子']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                              Text(
                                                tianpan['亥']!,
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff222426),
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        children: [
                                          TimeStemsPlainText(
                                            xunKong: xunKong,
                                            branch: tianpan['酉']!,
                                            stems: tiangan['酉']!,
                                          ),
                                          SizedBox(height: 8.w),
                                          TimeStemsPlainText(
                                            xunKong: xunKong,
                                            branch: tianpan['戌']!,
                                            stems: tiangan['戌']!,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        children: [
                                          Text(
                                            tinajiang['酉']!,
                                            style: TextStyle(
                                              color: const Color(0xfff1ac62),
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(height: 8.w),
                                          Text(
                                            tinajiang['戌']!,
                                            style: TextStyle(
                                              color: const Color(0xfff1ac62),
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.w),
                                  // Fourth Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TimeStemsPlainText(
                                        xunKong: xunKong,
                                        branch: tianpan['寅']!,
                                        stems: tiangan['寅']!,
                                      ),
                                      TimeStemsPlainText(
                                        xunKong: xunKong,
                                        branch: tianpan['丑']!,
                                        stems: tiangan['丑']!,
                                      ),
                                      TimeStemsPlainText(
                                        xunKong: xunKong,
                                        branch: tianpan['子']!,
                                        stems: tiangan['子']!,
                                      ),
                                      TimeStemsPlainText(
                                        xunKong: xunKong,
                                        branch: tianpan['亥']!,
                                        stems: tiangan['亥']!,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.w),
                                  // Second Row
                                  Text(
                                    '${tinajiang['寅']}${tinajiang['丑']}${tinajiang['子']}${tinajiang['亥']}',
                                    style: TextStyle(
                                      color: const Color(0xfff1ac62),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.w,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 18.w),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: input.guaType == 2 ? 54.w : 0.w),
                                child: Flex(
                                  direction: input.guaType == 1
                                      ? Axis.vertical
                                      : Axis.horizontal,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              result.sike['4']!.split('')[0],
                                              style: TextStyle(
                                                color: const Color(0xfff1ac62),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                            Text(
                                              result.sike['3']!.split('')[0],
                                              style: TextStyle(
                                                color: const Color(0xfff1ac62),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                            Text(
                                              result.sike['2']!.split('')[0],
                                              style: TextStyle(
                                                color: const Color(0xfff1ac62),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                            Text(
                                              result.sike['1']!.split('')[0],
                                              style: TextStyle(
                                                color: const Color(0xfff1ac62),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.w),
                                        Row(
                                          children: [
                                            Text(
                                              result.sike['4']!.split('')[1],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                            Text(
                                              result.sike['3']!.split('')[1],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                            Text(
                                              result.sike['2']!.split('')[1],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                            Text(
                                              result.sike['1']!.split('')[1],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.w),
                                        Row(
                                          children: [
                                            Text(
                                              result.sike['4']!.split('')[2],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                            Text(
                                              result.sike['3']!.split('')[2],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                            Text(
                                              result.sike['2']!.split('')[2],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                            Text(
                                              result.sike['1']!.split('')[2],
                                              style: TextStyle(
                                                color: const Color(0xff88898d),
                                                fontSize: 30.sp,
                                                fontFamily: 'SourceHanSerifCN',
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 2.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 18.w, height: 108.w),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              result.sanchuan['1']!
                                                  .split('')[0],
                                              style: TextStyle(
                                                color: const Color(0xff88898d),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              result.sanchuan['1']!
                                                          .split('')[1] ==
                                                      '空'
                                                  ? '    '
                                                  : result.sanchuan['1']!
                                                      .split('')[1],
                                              style: TextStyle(
                                                color: const Color(0xff88898d),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              result.sanchuan['1']!
                                                  .split('')[2],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              result.sanchuan['1']!
                                                  .split('')[3],
                                              style: TextStyle(
                                                color: const Color(0xfff1ac62),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 8.w),
                                        Row(
                                          children: [
                                            Text(
                                              result.sanchuan['2']!
                                                  .split('')[0],
                                              style: TextStyle(
                                                color: const Color(0xff88898d),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              result.sanchuan['2']!
                                                          .split('')[1] ==
                                                      '空'
                                                  ? '    '
                                                  : result.sanchuan['2']!
                                                      .split('')[1],
                                              style: TextStyle(
                                                color: const Color(0xff88898d),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              result.sanchuan['2']!
                                                  .split('')[2],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              result.sanchuan['2']!
                                                  .split('')[3],
                                              style: TextStyle(
                                                color: const Color(0xfff1ac62),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 8.w),
                                        Row(
                                          children: [
                                            Text(
                                              result.sanchuan['3']!
                                                  .split('')[0],
                                              style: TextStyle(
                                                color: const Color(0xff88898d),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              result.sanchuan['3']!
                                                          .split('')[1] ==
                                                      '空'
                                                  ? '    '
                                                  : result.sanchuan['3']!
                                                      .split('')[1],
                                              style: TextStyle(
                                                color: const Color(0xff88898d),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              result.sanchuan['3']!
                                                  .split('')[2],
                                              style: TextStyle(
                                                color: const Color(0xff222426),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              result.sanchuan['3']!
                                                  .split('')[3],
                                              style: TextStyle(
                                                color: const Color(0xfff1ac62),
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(height: 20.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 30.w),
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
                                      '课       体：',
                                      style: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 1.25,
                                      ),
                                    ),
                                    SizedBox(width: 20.w),
                                    Expanded(
                                      child: Text(
                                        result.geju[0],
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: const Color(0xff222426),
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30.w),
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
                                            value: gender?.value ??
                                                Gender.male.value,
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
                                                  .where((element) =>
                                                      element.isNotEmpty)
                                                  .map((element) => PickerItem(
                                                      label: element,
                                                      value: element))
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
                                            zodiac != null
                                                ? '生肖:$zodiac'
                                                : '请选择生肖',
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
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 18.w,
                              children: const [
                                RelationDialogButton(label: '天干寄宫'),
                                RelationDialogButton(label: '三合'),
                                RelationDialogButton(label: '刑'),
                                RelationDialogButton(label: '害'),
                                RelationDialogButton(label: '破'),
                                RelationDialogButton(label: '六合'),
                                FivePhasesGrowth(),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.w),
                      GestureDetector(
                        onTap: () async {
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

class TimeStemsPlainText extends StatelessWidget {
  const TimeStemsPlainText(
      {super.key,
      required this.xunKong,
      required this.branch,
      required this.stems});

  final String xunKong;

  final String branch;

  final String stems;

  @override
  Widget build(BuildContext context) {
    return xunKong.contains(branch)
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 10.w, horizontal: 4.w),
            width: 24.w,
            height: 24.w,
            decoration: ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(
                  width: 2.w,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: const Color(0xff88898d),
                ),
              ),
            ),
            child: Center(
              child: Container(
                width: 16.w,
                height: 16.w,
                decoration: ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(
                      width: 2.w,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xff88898d),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Text(
            stems,
            style: TextStyle(
              color: const Color(0xff88898d),
              fontSize: 30.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.w,
            ),
          );
  }
}
