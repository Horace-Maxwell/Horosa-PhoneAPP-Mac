import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleHexagram extends StatelessWidget {
  const SingleHexagram({
    super.key,
    required this.line,
    required this.stems,
    required this.branch,
    required this.relatives,
    this.shiOrYing,
    this.isHighLight,
  });

  /// 天干
  final String stems;

  /// 地支
  final String branch;

  /// 六亲
  final String relatives;

  /// 世、应
  final String? shiOrYing;

  /// 爻
  final String line;

  /// 是否高亮显示
  final bool? isHighLight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          relatives,
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 24.r,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          '$stems$branch',
          style: TextStyle(
            color: const Color(0xFF222426),
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 5.w),
        SizedBox(
          width: 104.w,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 24.w,
                  decoration: ShapeDecoration(
                    color: (isHighLight ?? false) || line == '6' || line == '9' ? const Color(0xfff8cc76) :  const Color(0xff393b41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: line == '6' || line == '8',
                child: SizedBox(width: 6.w),
              ),
              Visibility(
                visible: line == '6' || line == '8',
                child: Expanded(
                  child: Container(
                    height: 24.w,
                    decoration: ShapeDecoration(
                      color: (isHighLight ?? false) || line == '6' ? const Color(0xfff8cc76) : const Color(0xff393b41),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 24.sp,
          child: Text(
            shiOrYing ?? '',
            style: TextStyle(
              color: const Color(0xff222426),
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Visibility(
          visible: line == '6',
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: SizedBox(
              width: 14.w,
              height: 14.w,
              child: CustomPaint(
                painter: XPainter(),
              ),
            ),
          ),
        ),
        Visibility(
          visible: line == '9',
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Container(
              width: 16.w,
              height: 16.w,
              decoration: ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(
                    width: 3.w,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xfff8cc76),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class XPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xfff8cc76)
      ..strokeWidth = 3.w
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
