import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/pages/liuren/form.dart';
import 'package:horosa/pages/qimen/form.dart';

class LiuYaoAppBarTitle extends StatelessWidget {
  const LiuYaoAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const QiMenFormPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  CurvedAnimation curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInExpo,
                  );

                  if (animation.status == AnimationStatus.forward) {
                    // 当进入页面时，禁用动画
                    return child;
                  }

                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(curvedAnimation),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Text(
            '奇门',
            style: TextStyle(
              color: const Color(0xff86878b),
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 56.w),
        Text(
          '六爻',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(width: 56.w),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LiuRenFormPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  CurvedAnimation curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInExpo,
                  );

                  if (animation.status == AnimationStatus.forward) {
                    // 当进入页面时，禁用动画
                    return child;
                  }

                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(curvedAnimation),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Text(
            '六壬',
            style: TextStyle(
              color: const Color(0xff86878b),
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 56.w)
      ],
    );
  }
}
