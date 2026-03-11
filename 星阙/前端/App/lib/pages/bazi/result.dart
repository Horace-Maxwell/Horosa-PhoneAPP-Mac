import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluwx/fluwx.dart';
import 'package:screenshot/screenshot.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/bazi.dart';
import 'package:horosa/pages/bazi/widgets/detailed_chart_screen.dart';
import 'package:horosa/pages/bazi/widgets/natal_chart_screen.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/utils/toast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'widgets/basic_info_screen.dart';

class BaZiResultPage extends StatefulWidget {
  static const String route = '/bazi/result';

  const BaZiResultPage({super.key});

  @override
  State<BaZiResultPage> createState() => _BaZiResultPageState();
}

class _BaZiResultPageState extends State<BaZiResultPage>
    with TickerProviderStateMixin {
  final ScreenshotController screenshotController = ScreenshotController();
  late TabController _controller;
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
    } else {
      toast('保存失败，请检查是否给星阙授权了相册权限～');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ArchiveItem;

    ArchiveItem<BaZiInput, BaZiResult, BaZiExtras> item = args.toBaZi();

    return Screenshot(
      controller: screenshotController,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: const Color(0xfffbfbfb),
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
            title: Text(
              '八字排盘',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xff222426),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(74.w),
              child: Material(
                color: const Color(0xff222426),
                child: TabBar(
                  controller: _controller,
                  labelColor: const Color(0xfff8cc76),
                  indicatorColor: const Color(0xfff8cc76),
                  indicatorWeight: 4.w,
                  dividerHeight: 0,
                  labelStyle: TextStyle(
                    color: const Color(0xffcccccc),
                    fontFamily: 'SourceHanSerifCN',
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelColor: const Color(0xffcdcdcd),
                  tabs: [
                    Tab(text: '基本信息', height: 48.w),
                    Tab(text: '原命局', height: 48.w),
                    Tab(text: '细盘', height: 48.w),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
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
                icon: SvgPicture.asset(
                  'assets/icons/share.svg',
                  width: 34.w,
                  height: 36.w,
                ),
              ),
              SizedBox(width: 24.w)
            ],
          ),
          body: Material(
            color: const Color(0xfffbfbfb),
            child: TabBarView(
              controller: _controller,
              children: [
                BasicInfoScreen(form: item.input),
                NatalChartScreen(form: item.input),
                DetailedChartScreen(form: item.input),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
