import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/constants/constant.dart';

class RelationDialogButton extends StatelessWidget {
  const RelationDialogButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              contentPadding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 80.w, left: 102.w, right: 102.w, bottom: 50.w),
                      width: 1.sw - 72.w,
                      height: 593.w,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36.r),
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          relationAssetsMap[label]!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30.w,
                      right: 30.w,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          width: 72.w,
                          child: Text(
                            '关闭',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
      child: Container(
        width: 134.w,
        padding: EdgeInsets.symmetric(vertical: 8.w),
        decoration: ShapeDecoration(
          color: Colors.transparent,
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
