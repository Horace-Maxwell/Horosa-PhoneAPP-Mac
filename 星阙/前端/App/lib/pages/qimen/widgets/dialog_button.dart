import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({super.key, required this.label, required this.child});

  final String label;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (context) => StatefulBuilder(builder: (context, setState) => child));
      },
      child: Container(
        width: 134.w,
        padding: EdgeInsets.symmetric(vertical: 8.w),
        decoration: ShapeDecoration(
          color: const Color(0xffffffff).withOpacity(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34.r),
            side: BorderSide(
              width: 1.w,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: const Color(0xff222426),
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xff222426),
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
