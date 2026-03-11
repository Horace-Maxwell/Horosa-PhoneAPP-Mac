import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 时间起卦
class TimeLines extends StatelessWidget {
  const TimeLines({super.key, this.onInit});

  final Function()? onInit;

  @override
  Widget build(BuildContext context) {
    if(context.mounted) {
      onInit?.call();
    }
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '上卦：(年支数＋月阴历数＋日阴历数) ÷ 8  取余数',
            style: TextStyle(
              color: const Color(0xff88898d),
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              height: 1.75,
            ),
          ),
          Text(
            '下卦：(年支数＋月阴历数＋日阴历数+时支数) ÷ 8  取余数',
            style: TextStyle(
              color: const Color(0xff88898d),
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              height: 1.75,
            ),
          ),
          Text(
            '动爻：(年支数＋月阴历数＋日阴历数＋时支数) ÷ 6 取余数',
            style: TextStyle(
              color: const Color(0xff88898d),
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              height: 1.75,
            ),
          ),
        ],
      ),
    );
  }
}
