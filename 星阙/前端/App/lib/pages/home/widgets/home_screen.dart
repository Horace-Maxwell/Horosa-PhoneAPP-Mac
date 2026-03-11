import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/constants/config.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/config.dart';
import 'package:horosa/models/liu_ren.dart';
import 'package:horosa/models/qi_men.dart';
import 'package:horosa/providers/auth.dart';
import 'package:horosa/providers/config.dart';
import 'package:horosa/services/liu_ren.dart';
import 'package:horosa/services/log.dart';
import 'package:horosa/services/qi_men.dart';
import 'package:horosa/utils/toast.dart';
import 'package:horosa/widgets/login_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lunar/lunar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:horosa/models/horosa.dart';
import 'package:horosa/pages/pages.dart';
import 'package:horosa/services/config.dart';
import 'icon_button_with_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  List<DockItem> docks = [];

  List<DockItem> get _defaultDocks => const [
        DockItem(name: '八字', sort: 4, ident: 'bazi', status: 1, logo: ''),
        DockItem(name: '六爻', sort: 3, ident: 'liuyao', status: 1, logo: ''),
        DockItem(name: '奇门', sort: 2, ident: 'qimen', status: 1, logo: ''),
        DockItem(name: '六壬', sort: 1, ident: 'liuren', status: 1, logo: ''),
      ];

  void _useFallbackDocks() {
    if (!mounted) {
      return;
    }
    setState(() {
      docks = _defaultDocks;
      loading = false;
    });
    context.read<ConfigProvider>().setDocks(docks);
  }

  Widget _buildDockIcon(DockItem dock) {
    final logo = dock.logo;
    if (logo.isNotEmpty) {
      try {
        final bytes = base64Decode(logo.split(',').last);
        return Image.memory(
          bytes,
          width: 75.w,
          height: 75.w,
        );
      } catch (_) {}
    }
    IconData iconData;
    switch (dock.ident) {
      case 'bazi':
        iconData = Icons.auto_awesome;
        break;
      case 'liuyao':
        iconData = Icons.account_tree;
        break;
      case 'qimen':
        iconData = Icons.grid_4x4;
        break;
      case 'liuren':
        iconData = Icons.blur_circular;
        break;
      default:
        iconData = Icons.circle;
    }
    return Container(
      width: 75.w,
      height: 75.w,
      decoration: BoxDecoration(
        color: const Color(0xfff8cc76),
        borderRadius: BorderRadius.circular(36.r),
      ),
      child: Icon(
        iconData,
        size: 42.w,
        color: const Color(0xff222426),
      ),
    );
  }

  Future<void> initialize() async {
    try {
      final res = await ConfigSvc.getDocks();
      if (!mounted) {
        return;
      }
      if (res.statusCode == 200 &&
          res.data['code'] == 0 &&
          res.data['data'] is List<dynamic>) {
        final loaded = (res.data['data'] as List<dynamic>)
            .map((e) => DockItem.fromJson(e as Map<String, dynamic>))
            .where((e) => e.status == 1)
            .toList();
        if (loaded.isNotEmpty) {
          loaded.sort((a, b) => b.sort.compareTo(a.sort));
          setState(() {
            docks = loaded;
            loading = false;
          });
          context.read<ConfigProvider>().setDocks(docks);
          return;
        }
      }
      _useFallbackDocks();
    } catch (_) {
      _useFallbackDocks();
    }
  }

  @override
  void initState() {
    super.initState();
    List<DockItem> d = context.read<ConfigProvider>().docks;
    if (d.isEmpty) {
      initialize();
    } else {
      setState(() {
        loading = false;
        docks = d;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: 1.sw,
            height: 716.w,
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/tower.png",
                  fit: BoxFit.fill,
                  width: 1.sw,
                  height: 716.w,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(512.w, 146.w, 116.w, 0),
                  child: Image.asset("assets/images/sun.png"),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(36.w, 146.w, 0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff222426),
                        borderRadius: BorderRadius.circular(999.r)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.w),
                      child: Text(
                        Horosa.getSolarTerms(),
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontFamily: 'SourceHanSansCN',
                          color: const Color(0xfff8cc76),
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(36.w, 219.w, 0, 0),
                  child: Text(
                    Horosa.getLunarMD(),
                    style: TextStyle(
                        fontSize: 60.sp,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff393b41)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(36.w, 309.w, 0, 0),
                  child: Text(
                    Horosa.getEightCharsDateYMDH(),
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        color: const Color(0xff393b41)),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36.w),
                    child: Container(
                      height: 130.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff222426),
                        borderRadius: BorderRadius.circular(36.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 72.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Horosa.getMansion(),
                                  style: TextStyle(
                                      color: const Color(0xfff8cc76),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 8.w),
                                Text(
                                  "今日吉神",
                                  style: TextStyle(
                                      color: const Color(0xffdf9673),
                                      fontSize: 24.sp),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              width: 1.w,
                              indent: 42.w,
                              endIndent: 42.w,
                              color: const Color(0x66f2ad63),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Horosa.getDailyYi(),
                                  style: TextStyle(
                                      color: const Color(0xfff8cc76),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 8.w),
                                Text(
                                  "今日适宜",
                                  style: TextStyle(
                                      color: const Color(0xffdf9673),
                                      fontSize: 24.sp),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              width: 1.w,
                              indent: 42.w,
                              endIndent: 42.w,
                              color: const Color(0x66f2ad63),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Horosa.getDailyJi(),
                                  style: TextStyle(
                                      color: const Color(0xfff8cc76),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 8.w),
                                Text(
                                  "今日忌讳",
                                  style: TextStyle(
                                      color: const Color(0xffdf9673),
                                      fontSize: 24.sp),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ((loading && docks.isEmpty) || docks.isNotEmpty)
              ? Padding(
                  padding: EdgeInsets.fromLTRB(36.w, 54.w, 36.w, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: loading
                        ? List.generate(4, (_) {
                            return Column(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: const Color(0xffeeeeee),
                                  highlightColor: const Color(0xffcccccc),
                                  child: Container(
                                    width: 75.w,
                                    height: 75.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff8cc76),
                                      borderRadius: BorderRadius.circular(36.r),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.w),
                                Shimmer.fromColors(
                                  baseColor: const Color(0xffeeeeee),
                                  highlightColor: const Color(0xffcccccc),
                                  child: Container(
                                    width: 60.w,
                                    height: 36.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffacacac),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })
                        : List.generate(docks.length, (index) {
                            return IconButtonWithText(
                              icon: _buildDockIcon(docks[index]),
                              label: docks[index].name,
                              onPressed: () {
                                if (!context.read<AuthProvider>().isLoggedIn) {
                                  if (context.read<AuthProvider>().needRemind) {
                                    LoginDialog(
                                      onCancel: () {
                                        context
                                            .read<AuthProvider>()
                                            .setNeedRemind(false);
                                      },
                                    ).show(context);
                                    return;
                                  }
                                }
                                Navigator.pushNamed(context,
                                    dockRoutes[docks[index].ident] ?? '/');
                              },
                            );
                          }),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: EdgeInsets.fromLTRB(36.w, 42.w, 36.w, 0),
            child: GestureDetector(
              onTap: () async {
                const String url = 'https://b23.tv/nLuK1rg';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              },
              child: Container(
                height: 160.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xfff8ecd2), Color(0xffffd077)],
                  ),
                  borderRadius: BorderRadius.circular(36.r),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(36.w, 30.w, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28.r),
                            color: const Color(0xff333333),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 2.w),
                            child: Text(
                              '视频',
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  color: const Color(0xffffffff)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(36.w, 73.w, 36.w, 30.w),
                        child: Text(
                          '阴阳与卦象 ',
                          style: TextStyle(
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff222426),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(488.w, 94.w, 36.w, 30.w),
                        child: Text(
                          '查看详情> ',
                          style: TextStyle(
                              fontSize: 24.sp, color: const Color(0xff222426)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(36.w, 48.w, 36.w, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, CoinLinesPage.route);
                  },
                  child: Container(
                    width: 316.w,
                    height: 287.w,
                    decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(36.r),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 8.w),
                              blurRadius: 12.r,
                              color: const Color(0x14222327))
                        ]),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 200.w,
                            height: 200.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0x3bf8cc76),
                                      Color(0x00f8cc76)
                                    ])),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(67.w, 143.w, 29.w, 38.w),
                          child: Image.asset('assets/images/qian-yao.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30.w, 19.w, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "金钱爻",
                                style: TextStyle(
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff393b41)),
                              ),
                              Text(
                                "六爻测前路",
                                style: TextStyle(fontSize: 24.sp),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(22.w, 0, 0, 0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Solar solar = Solar.fromDate(DateTime.now());
                          LiuRenInput input = LiuRenInput(
                            guaType: 1,
                            question: '',
                            country: '中国',
                            address: '默认地点 北京',
                            hseb: LiuRenHseb(
                              day: solar.getLunar().getDayInGanZhi(),
                              hour: solar.getLunar().getTimeInGanZhi(),
                            ),
                            guaTime: GuaTime(
                              year: solar.getYear(),
                              month: solar.getMonth(),
                              day: solar.getDay(),
                              hour: solar.getHour(),
                              minute: solar.getMinute(),
                            ),
                            hourNum: null,
                            month: solar.getLunar().getMonthInChinese(),
                            jieqi:
                                solar.getLunar().getPrevJieQi(true).getName(),
                          );
                          try {
                            final res = await LiuRenSvc.getLiuRenResult(input);
                            if (!context.mounted) return;
                            if (res.statusCode == 200 &&
                                res.data['code'] == 0) {
                              Navigator.of(context).pushNamed(
                                LiuRenResultPage.route,
                                arguments: ArchiveItem(
                                  extras: {},
                                  id: res.data['data']['record_id'] ?? 0,
                                  input: input.toJson(),
                                  output: res.data['data'],
                                  type: 3,
                                  saveType: 1,
                                ),
                              );
                              LogSvc.logging(LogType.liuren);
                              return;
                            }
                            toast(res.data['msg'] ?? '起课失败，请稍后重试');
                          } catch (_) {
                            if (!context.mounted) return;
                            toast('起课失败，请检查网络后重试');
                          }
                        },
                        child: Container(
                          width: 316.w,
                          height: 134.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(36.r),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 8.w),
                                blurRadius: 12.r,
                                color: const Color(0x14222327),
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 134.w,
                                  height: 134.w,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0x3bf8cc76),
                                            Color(0x00f8cc76)
                                          ])),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    211.w, 28.w, 29.w, 30.w),
                                child: Image.asset(
                                    'assets/images/tian-shi-ke.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(30.w, 19.w, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "天时课",
                                      style: TextStyle(
                                          fontSize: 40.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff393b41)),
                                    ),
                                    Text(
                                      "六壬见余生",
                                      style: TextStyle(fontSize: 24.sp),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 19.w),
                      GestureDetector(
                        onTap: () async {
                          Solar solar = Solar.fromDate(DateTime.now());
                          QiMenInput input = QiMenInput(
                            guaType: 2,
                            question: '',
                            country: '中国',
                            address: '默认地点 北京',
                            guaTime: QiMenGuaTime(
                              year: solar.getYear(),
                              month: solar.getMonth(),
                              day: solar.getDay(),
                              hour: solar.getHour(),
                              minute: solar.getMinute(),
                            ),
                          );
                          try {
                            final res = await QiMenSvc.getQiMenResult(input);
                            if (!context.mounted) return;
                            if (res.statusCode == 200 &&
                                res.data['code'] == 0) {
                              Navigator.of(context).pushNamed(
                                QiMenResultPage.route,
                                arguments: ArchiveItem(
                                  extras: {},
                                  id: res.data['data']['record_id'] ?? 0,
                                  input: input.toJson(),
                                  output: res.data['data'],
                                  type: 3,
                                  saveType: 1,
                                ),
                              );
                              LogSvc.logging(LogType.qimen);
                              return;
                            }
                            toast(res.data['msg'] ?? '起课失败，请稍后重试');
                          } catch (_) {
                            if (!context.mounted) return;
                            toast('起课失败，请检查网络后重试');
                          }
                        },
                        child: Container(
                          width: 316.w,
                          height: 134.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(36.r),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 8.w),
                                blurRadius: 12.r,
                                color: const Color(0x14222327),
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 134.w,
                                  height: 134.w,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0x3bf8cc76),
                                            Color(0x00f8cc76)
                                          ])),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    211.w, 28.w, 29.w, 30.w),
                                child: Image.asset(
                                    'assets/images/dun-jia-shi.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(30.w, 19.w, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "遁甲式",
                                      style: TextStyle(
                                          fontSize: 40.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff393b41)),
                                    ),
                                    Text(
                                      "遁甲知君心",
                                      style: TextStyle(fontSize: 24.sp),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 30.w)
        ],
      ),
    );
  }
}
