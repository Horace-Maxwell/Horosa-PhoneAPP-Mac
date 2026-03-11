import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconButtonWithText extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const IconButtonWithText(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: 15.w),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xff222426),
              fontWeight: FontWeight.w600,
              fontSize: 30.sp,
            ),
          )
        ],
      ),
    );
  }
}
