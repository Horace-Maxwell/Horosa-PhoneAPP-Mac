import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBar extends StatefulWidget {
  final int? current;
  final Function onChange;

  const BottomNavBar({this.current, required this.onChange, super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.current ?? 0,
      backgroundColor: const Color(0xff222426),
      selectedFontSize: 20.sp,
      selectedItemColor: const Color(0xfff8cc76),
      unselectedFontSize: 20.sp,
      unselectedItemColor: const Color(0xfff8cc76),
      onTap: (index) {
        widget.onChange(index);
      },
      items: [
        BottomNavigationBarItem(
          label: '首页',
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            width: 48.w,
            height: 48.w,
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/home-active.svg',
            width: 48.w,
            height: 48.w,
          ),
        ),
        BottomNavigationBarItem(
          label: '档案',
          icon: SvgPicture.asset(
            'assets/icons/plus.svg',
            width: 48.w,
            height: 48.w,
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/plus-active.svg',
            width: 48.w,
            height: 48.w,
          ),
        ),
        BottomNavigationBarItem(
          label: '我的',
          icon: SvgPicture.asset(
            'assets/icons/user.svg',
            width: 48.w,
            height: 48.w,
          ),
          activeIcon: SvgPicture.asset(
            'assets/icons/user-active.svg',
            width: 48.w,
            height: 48.w,
          ),
        ),
      ],
    );
  }
}
