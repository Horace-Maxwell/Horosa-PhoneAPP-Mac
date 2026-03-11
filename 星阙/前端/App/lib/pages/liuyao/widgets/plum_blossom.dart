import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/liu_lines.dart';

/// 梅花卦
class PlumBlossom extends StatelessWidget {
  const PlumBlossom({super.key, this.plum, required this.main});

  final Plum? plum;
  final String main;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '梅花卦',
            style: TextStyle(
              color: const Color(0xff222426),
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hexagram(
                      label: '主 · ${plum!.gua.name}',
                      value: plum!.gua.value,
                    ),
                    Hexagram(
                      label: '互 · ${plum!.huGua.name}',
                      value: plum!.huGua.value,
                    ),
                    Hexagram(
                      label: '变 · ${plum!.changeGua.name}',
                      value: plum!.changeGua.value,
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hexagram(
                      label: '错 · ${plum!.cuoGua.name}',
                      value: plum!.cuoGua.value,
                      direction: VerticalDirection.up,
                    ),
                    Hexagram(
                      label: '综 · ${plum!.zongGua.name}',
                      value: plum!.zongGua.value,
                      direction: VerticalDirection.up,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Hexagram extends StatelessWidget {
  const Hexagram(
      {super.key, required this.label, required this.value, this.direction});

  final String label;
  final String value;
  final VerticalDirection? direction;

  @override
  Widget build(BuildContext context) {
    List<String> lines = value.split('').reversed.toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        verticalDirection: direction ?? VerticalDirection.down,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0x99393b41),
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              height: 1.75,
            ),
          ),
          Column(
            children: List.generate(
              lines.length,
              (index) => SizedBox(
                width: 84.w,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 8.w,
                        margin: EdgeInsets.symmetric(vertical: 6.w),
                        decoration: ShapeDecoration(
                          color: lines[index] == '6' || lines[index] == '9' ? const Color(0xfff8cc76) : const Color(0xff393b41),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: lines[index] == '8' || lines[index] == '6',
                      child: Expanded(
                        child: Container(
                          height: 8.w,
                          margin:
                              EdgeInsets.only(left: 4.w, top: 6.w, bottom: 6.w),
                          decoration: ShapeDecoration(
                            color: lines[index] == '6' ? const Color(0xfff8cc76) : const Color(0xff393b41),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
