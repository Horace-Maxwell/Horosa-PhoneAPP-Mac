import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutUsPage extends StatelessWidget {
  static String route = '/profile/about-us';

  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffbfbfb),
        surfaceTintColor: const Color(0xfffbfbfb),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrow-left.svg',
            width: 17.w,
            height: 32.w,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          '关于我们',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 180.w),
                  width: 153.w,
                  height: 153.w,
                  decoration: ShapeDecoration(
                    color: const Color(0xff222426),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(153.r),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/logo.svg',
                      width: 118.w,
                      height: 118.w,
                    ),
                  ),
                ),
                SizedBox(height: 48.w),
                Text(
                  '星阙',
                  style: TextStyle(
                    color: const Color(0xff222426),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 20.w),
                Text(
                  'V1.00版',
                  style: TextStyle(
                    color: const Color(0xff222426),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 83.w),
                Text(
                  '星阙，一款融合了中国传统文化精髓与现代社交理念的高端社交应用，它不仅仅是一个平台，更是一座连接古老智慧与现代心灵的桥梁。在这个快节奏的时代，星阙以其独特的中国风玄学元素，为用户提供了一个寻找共鸣、探索内心世界的宁静空间。',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: const Color(0xff222426),
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.67,
                  ),
                ),
                SizedBox(height: 120.w),
                Text(
                  '特别鸣谢',
                  style: TextStyle(
                      color: const Color(0xff333333),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 48.w),
                Text(
                  '郑大哥',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xff222426),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 90.w),
                Text(
                  '开发团队',
                  style: TextStyle(
                      color: const Color(0xff333333),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 48.w),
                Text(
                  '荀爽',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xff222426),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 48.w),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return Wrap(
                      runAlignment: WrapAlignment.center,
                      runSpacing: 40.w,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 96.w),
                          width: 0.5 * width,
                          child: Text(
                            '项目: Lei',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 96.w),
                          child: Text(
                            '产品: 浩',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 96.w),
                          width: 0.5 * width,
                          child: Text(
                            '交互: 艺',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 96.w),
                          width: 0.5 * width,
                          child: Text(
                            '前端: Kahn',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 96.w),
                          width: 0.5 * width,
                          child: Text(
                            '后端: Lost',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 96.w),
                          width: 0.5 * width,
                          child: Text(
                            '美术: 东仔',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 90.w),
                Text(
                  '致谢',
                  style: TextStyle(
                      color: const Color(0xff333333),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 48.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 45.w,
                    runSpacing: 30.w,
                    children: [
                      Text(
                        'Robert Zoller',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'João Ventura',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '张小姐',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '王师侄',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '许褚',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '乡村振兴',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '海岸边的诗人',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Moira',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Kentang',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '所有开源追随者',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
