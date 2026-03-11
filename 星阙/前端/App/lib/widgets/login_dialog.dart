import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/pages/login/page.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key, this.onCancel});

  final void Function()? onCancel;

  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SimpleDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 72.w),
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        children: [
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 64.w),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xff393b41), Color(0xff222426)],
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.w,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: const Color(0xfff8cc76),
                ),
                borderRadius: BorderRadius.circular(36.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/hello.png',
                          width: 152.w,
                          height: 49.w,
                        ),
                        SizedBox(height: 24.w),
                        Text(
                          '欢迎使用星阙',
                          style: TextStyle(
                            color: const Color(0xfff8cc76),
                            fontSize: 30.sp,
                            fontFamily: 'SourceHanSansCN',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 35.w),
                        Container(
                          width: 80.w,
                          height: 10.w,
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Color(0xffffefcf), Color(0xffffca64)],
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r)),
                          ),
                        )
                      ],
                    ),
                    Image.asset('assets/images/bell.png',
                        width: 150.w, height: 150.w)
                  ],
                ),
                SizedBox(height: 48.w),
                Text(
                  '一屏观万象，玄语诉心声',
                  style: TextStyle(
                    color: const Color(0xfff8cc76),
                    fontSize: 30.sp,
                    fontFamily: 'SourceHanSansCN',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 87.w),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(LoginPage.route);
                  },
                  child: Container(
                    height: 86.w,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xffffefcf), Color(0xffffca64)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(43.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '前往登录',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 36.sp,
                          fontFamily: 'SourceHanSansCN',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 80.w),
            child: Stack(
              children: [
                Align(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onCancel?.call();
                    },
                    child: Container(
                      width: 82.w,
                      height: 82.w,
                      decoration: ShapeDecoration(
                        color: const Color(0xff222426),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(41.r),
                          side: BorderSide(
                            width: 1.w,
                            color: const Color(0xfff8cc76),
                          )
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(28.w),
                        child: CustomPaint(
                          painter: XPainter(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class XPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xfff8cc76)
      ..strokeWidth = 2.w
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
