import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/constants/six_lines.dart';
import 'package:horosa/models/liu_lines.dart';

class SpecifiedLines extends StatefulWidget {
  const SpecifiedLines({super.key, this.onChange});

  final Function(List<LineTypes>)? onChange;

  @override
  State<SpecifiedLines> createState() => _SpecifiedLinesState();
}

class _SpecifiedLinesState extends State<SpecifiedLines> {
  List<LineTypes> divination = List.generate(6, (_) => LineTypes.shaoyang);

  @override
  void initState() {
    super.initState();
    widget.onChange?.call(divination);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            offset: Offset(0, 8.r),
            spreadRadius: -4.r,
          )
        ],
      ),
      child: Column(
        children: List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 30.w),
            child: Row(
              children: [
                Text(
                  linesName[5 - index],
                  style: TextStyle(
                    color: const Color(0xff222426),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 30.w),
                Expanded(
                  child: Line(
                    line: divination[index],
                    onChange: (line) {
                      setState(() {
                        divination[index] = line;
                      });
                    },
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class Line extends StatelessWidget {
  const Line({super.key, required this.line, this.onChange});

  /// 爻象（少阴、少阳、老阴、老阳）
  final LineTypes line;

  final Function(LineTypes)? onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              onChange?.call(LineTypes.getLineTypeByValue(line.value * -1));
            },
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    height: 35.w,
                    decoration: ShapeDecoration(
                      color: const Color(0xff393b41),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: [1, -3].contains(line.value),
                  child: SizedBox(width: 26.w),
                ),
                Visibility(
                  visible: [1, -3].contains(line.value),
                  child: Expanded(
                    child: Container(
                      height: 35.w,
                      decoration: ShapeDecoration(
                        color: const Color(0xff393b41),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(width: 30.w),
        GestureDetector(
          onTap: () {
            onChange?.call(LineTypes.getLineTypeByValue(line.value ^ -4));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
            decoration: ShapeDecoration(
              color: line.value % 3 == 0
                  ? const Color(0xff393b41)
                  : const Color(0xffcccccc),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r)),
            ),
            child: Text(
              '动',
              style: TextStyle(
                color: line.value % 3 == 0
                    ? const Color(0xfff8cc76)
                    : const Color(0xffffffff),
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ),
        )
      ],
    );
  }
}
