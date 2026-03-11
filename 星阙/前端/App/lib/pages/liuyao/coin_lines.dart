import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/liu_lines.dart';
import 'package:horosa/pages/liuyao/result.dart';
import 'package:horosa/services/log.dart';
import 'package:horosa/services/six_line.dart';
import 'package:lunar/lunar.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:horosa/constants/six_lines.dart';
import 'package:horosa/pages/liuyao/widgets/coin_flip.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/utils/toast.dart';
import 'package:vibration/vibration.dart';

class CoinLinesPage extends StatefulWidget {
  static const String route = '/coin-lines';

  const CoinLinesPage({super.key});

  @override
  State<CoinLinesPage> createState() => _CoinLinesPageState();
}

class _CoinLinesPageState extends State<CoinLinesPage> {
  List<LineTypes> lines = [];
  List<double> coins = List.generate(3, (_) => 1);
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  late AudioPlayer player = AudioPlayer();
  bool isShaking = false;
  int index = 0;
  Timer? timer;
  int start = 5; // 倒计时的初始值（秒）
  String countdown = '';

  double _randomOneOrMinus() {
    double num = Random().nextBool() ? 1 : -1;
    return num;
  }

  Future<void> _playSound() async {
    player.setReleaseMode(ReleaseMode.loop);
    await player.setPlaybackRate(0.9);
    await player.play(AssetSource('voices/copper-coin.wav'), volume: 0.5);
    await Future.delayed(const Duration(seconds: 3));
    await player.stop();
  }

  shake() async {
    if (isShaking) {
      return;
    }
    if (index > 5) {
      return;
    }
    setState(() {
      isShaking = true;
      coins = List.generate(3, (_) => 0);
    });
    if (!LocalMode.enabled) {
      try {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator) {
          Vibration.vibrate();
        }
      } catch (_) {}
    }
    _playSound();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        coins = List.generate(3, (_) => _randomOneOrMinus());
        lines.add(LineTypes.getLineTypeByValue(
            coins.fold(0, (a, b) => (a + b).toInt())));
        player.stop();
        isShaking = false;
        index++;
        if (index > 5) {
          startTimer();
        }
      });
    });
  }

  Future<void> divine() async {
    Solar solar = Solar.fromDate(DateTime.now());
    LiuYaoInput input = LiuYaoInput(
      guaType: 1,
      question: '',
      country: '中国',
      address: '默认地点 北京',
      lines: lines.fold('', (a, b) => a + b.line),
      jieqi: solar.getLunar().getPrevJieQi(true).getName(),
      hseb: Hseb(
        year: solar.getLunar().getYearInGanZhi(),
        month: solar.getLunar().getMonthInGanZhi(),
        day: solar.getLunar().getDayInGanZhi(),
        hour: solar.getLunar().getTimeInGanZhi(),
      ),
      guaTime: LiuYaoGuaTime(
        year: solar.getYear(),
        month: solar.getMonth(),
        day: solar.getDay(),
        hour: solar.getHour(),
        minute: solar.getMinute(),
      ),
    );
    try {
      final res = await SixLineSvc.getSixLinesResult(input);
      if (!mounted) return;
      if (res.statusCode == 200 && res.data['code'] == 0) {
        Navigator.of(context).pushNamed(
          LiuYaoResultPage.route,
          arguments: ArchiveItem(
            extras: {},
            id: res.data['data']['record_id'] ?? 0,
            input: input.toJson(),
            output: res.data['data'],
            type: 2,
            saveType: 1,
          ),
        );
        LogSvc.logging(LogType.sixline);
        return;
      }
      toast(res.data['msg'] ?? '起卦失败，请稍后重试');
    } catch (_) {
      if (!mounted) return;
      toast('起卦失败，请检查网络后重试');
    }
  }

  void startTimer() {
    countdown = '（$start 秒）';
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (start > 1) {
        setState(() {
          start--;
          countdown = '（$start 秒）';
        });
      } else {
        setState(() {
          countdown = '';
        });
        t.cancel(); // 倒计时结束时取消计时器
        divine(); // 执行
      }
    });
  }

  @override
  void initState() {
    super.initState();

    if (!LocalMode.enabled) {
      final accelerometerEvents = accelerometerEventStream();
      _accelerometerSubscription =
          accelerometerEvents.listen((AccelerometerEvent event) {
        int value = 20;
        if (event.x.abs() > value ||
            event.y.abs() > value ||
            event.z.abs() > value) {
          shake();
        }
      });
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        title: Text(
          '金钱爻',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xfff8edd3), Color(0xfff8cc76)],
          ),
        ),
        child: Stack(
          children: [
            Align(
              child: SvgPicture.asset(
                'assets/svgs/shake.svg',
                width: 294.w,
                height: 268.w,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  if (index < 6) {
                    shake();
                  } else {
                    timer?.cancel(); // 倒计时结束时取消计时器
                    divine(); // 执行
                    setState(() {
                      countdown = '';
                    });
                  }
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 36.w, vertical: 56.w),
                  height: 86.w,
                  decoration: ShapeDecoration(
                    color: index < 6 ? Colors.white : const Color(0xff222426),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(43.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      index < 6 ? '打卦' : '起卦$countdown',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xfff1ac62),
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 200.w),
                padding: EdgeInsets.symmetric(horizontal: 36.w),
                child: Column(
                  children: [
                    Text(
                      index < 6 ? linesName[index] : '打卦完成',
                      style: TextStyle(
                        color: const Color(0xffe69635),
                        fontSize: 48.sp,
                        fontFamily: 'SourceHanSansCN',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 72.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            width: 140.w,
                            height: 140.w,
                            child: CoinFlip(
                              value: coins[0],
                            )),
                        SizedBox(
                            width: 140.w,
                            height: 140.w,
                            child: CoinFlip(
                              value: coins[1],
                            )),
                        SizedBox(
                            width: 140.w,
                            height: 140.w,
                            child: CoinFlip(
                              value: coins[2],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 180.w),
                width: 1.sw,
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: List.generate(
                    lines.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '【${linesName[index]}】',
                              style: TextStyle(
                                color: const Color(0xffe69635),
                                fontSize: 30.sp,
                                fontFamily: 'SourceHanSansCN',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 228.w,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 24.w,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xffe69635),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        [1, -3].contains(lines[index].value),
                                    child: Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 15.w),
                                        height: 24.w,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xffe69635),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: lines[index].value == 3,
                                    child: Container(
                                      width: 24.w,
                                      height: 24.w,
                                      decoration: ShapeDecoration(
                                        shape: OvalBorder(
                                          side: BorderSide(
                                            width: 4.w,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                            color: const Color(0xffe69635),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: lines[index].value == -3,
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: CustomPaint(
                                        painter: XPainter(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class XPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffe69635)
      ..strokeWidth = 4.w
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
