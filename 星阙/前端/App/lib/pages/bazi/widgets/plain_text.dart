import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlainText extends StatelessWidget {
  const PlainText({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.sp * label.length,
      height: 24.w,
      child: OverflowBox(
        maxWidth: 25.sp * (label.length + 1),
        maxHeight: 24.w,
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}