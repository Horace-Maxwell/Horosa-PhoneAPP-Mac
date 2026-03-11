import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/liu_lines.dart';
import 'package:horosa/utils/toast.dart';
import 'coin_flip.dart';

/// 模拟摇卦
class SimulateLines extends StatefulWidget {
  const SimulateLines({super.key, this.onChange});

  final Function(List<LineTypes?>)? onChange;

  @override
  State<SimulateLines> createState() => _SimulateLinesState();
}

class _SimulateLinesState extends State<SimulateLines> {
  List<LineTypes?> divination = List.generate(6, (_) => null);
  List<double> coins = [1, 1, 1];
  bool isRunning = false;
  int index = 0;

  double _randomOneOrMinus() {
    double num = Random().nextBool() ? 1 : -1;
    return num;
  }

  @override
  void initState() {
    super.initState();
    widget.onChange?.call(divination);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.w),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 308.w,
            child: GestureDetector(
              onTap: () {
                if(isRunning) {
                  return;
                }
                if (index == 6) {
                  toast('摇卦已完成', context: context);
                  return;
                }
                setState(() {
                  coins = [0, 0, 0];
                  isRunning = true;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    // 随机 1 或 -1
                    coins = List.generate(3, (_) => _randomOneOrMinus());
                    divination[index] = LineTypes.getLineTypeByValue(
                        coins.fold(0, (a, b) => (a + b).toInt()));
                    index++;
                    isRunning = false;
                    toast(index == 6 ? '摇卦已完成' : '还需要摇${6 - index}次', context: context);
                    widget.onChange?.call(divination.reversed.toList());
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 76.w,
                    height: 76.w,
                    child: CoinFlip(
                      value: coins[0],
                    ),
                  ),
                  SizedBox(
                    width: 76.w,
                    height: 76.w,
                    child: CoinFlip(
                      value: coins[1],
                    ),
                  ),
                  SizedBox(
                    width: 76.w,
                    height: 76.w,
                    child: CoinFlip(
                      value: coins[2],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.w),
          Text(
            '点击铜钱开始摇卦，每次2秒后自动停止，再点击开始下一爻',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xffcccccc),
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 36.w),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 56.w,
            runSpacing: 30.w,
            children: [
              SizedBox(
                width: 210.w,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '第一次：',
                        style: TextStyle(
                          color: const Color(0xFF393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: divination[0]?.label ?? '',
                        style: TextStyle(
                          color: const Color(0x99393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 210.w,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '第四次：',
                        style: TextStyle(
                          color: const Color(0xFF393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: divination[3]?.label ?? '',
                        style: TextStyle(
                          color: const Color(0x99393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 210.w,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '第二次：',
                        style: TextStyle(
                          color: const Color(0xFF393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: divination[1]?.label ?? '',
                        style: TextStyle(
                          color: const Color(0x99393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 210.w,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '第五次：',
                        style: TextStyle(
                          color: const Color(0xFF393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: divination[4]?.label ?? '',
                        style: TextStyle(
                          color: const Color(0x99393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 210.w,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '第三次：',
                        style: TextStyle(
                          color: const Color(0xFF393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: divination[2]?.label ?? '',
                        style: TextStyle(
                          color: const Color(0x99393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 210.w,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '第六次：',
                        style: TextStyle(
                          color: const Color(0xFF393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: divination[5]?.label ?? '',
                        style: TextStyle(
                          color: const Color(0x99393B41),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
