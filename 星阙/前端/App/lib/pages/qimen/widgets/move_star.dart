import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/constants/shen_sha.dart';
import 'package:horosa/models/circular_doubly_linked_list.dart';
import 'package:horosa/models/qi_men.dart';
import 'package:horosa/utils/log.dart';
import 'package:lunar/lunar.dart';

/// 移星
class MoveStar extends StatefulWidget {
  const MoveStar({super.key, required this.lunar, required this.result, required this.branch, required this.kong, this.seal});

  final Lunar lunar;
  final QiMenResult result;
  final String branch;
  final String kong;
  final int? seal;

  @override
  State<MoveStar> createState() => _MoveStarState();
}

class _MoveStarState extends State<MoveStar> {
  CircularDoublyLinkedList<String> list = CircularDoublyLinkedList();
  List<String> indexes = ['1', '2', '3', '6', '9', '8', '7', '4'];
  List<String> indexed = ['1', '2', '3', '6', '9', '8', '7', '4'];
  List<String> titles = [
    '原宫',
    '顺转一宫',
    '顺转二宫',
    '顺转三宫',
    '顺转四宫',
    '顺转五宫',
    '顺转六宫',
    '顺转七宫',
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
    for (String element in indexes) {
      list.add(element);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.only(bottom: 30.w),
      insetPadding: EdgeInsets.symmetric(horizontal: 36.w),
      backgroundColor: Colors.white,
      children: [
        Container(
          padding:
          EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.r),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '关闭',
                    style: TextStyle(
                      color: const Color(0xff222426),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 1.sw,
                  padding: EdgeInsets.only(top: 56.w),
                  child: Row(
                    children: [
                      index == 0
                          ? SizedBox(width: 32.w)
                          : GestureDetector(
                        onTap: () {
                          setState(() {
                            index -= 1;
                            List<String> result = [];
                            for (String element in indexed) {
                              String ele = list.find(element)!.next!.data;
                              result.add(ele);
                              Log.d('逆转 >>>> $ele');
                            }
                            indexed = result;
                          });
                        },
                        child: Container(
                          width: 32.w,
                          height: 56.w,
                          color: Colors.white,
                          child: SvgPicture.asset(
                            'assets/icons/arrow-left.svg',
                            width: 32.w,
                            height: 56.w,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              margin:
                              EdgeInsets.symmetric(horizontal: 32.w),
                              child: Column(
                                children: [
                                  Container(
                                    height: 36.w,
                                    color: const Color(0xff393b41),
                                    child: Center(
                                      child: Text(
                                        titles[index],
                                        style: TextStyle(
                                          color: const Color(0xfff8cc76),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Table(
                                    border: TableBorder.all(color: const Color(0xffcdcdcd), width: 1.w),
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              height: 180.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 10.w),
                                              color: const Color(0xfff6f6f6),
                                              child: Stack(
                                                children: [
                                                  Visibility(
                                                    visible: '辰巳'.contains(ShenShaUtil.OTHER_DAY_BRANCH['日马']![widget.branch]!.join('')),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10.w, right: 10.w),
                                                        child: SvgPicture.asset(
                                                          'assets/svgs/horse.svg',
                                                          width: 26.w,
                                                          height: 20.w,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.tianpan[indexed[0]] ?? '',
                                                            style: TextStyle(
                                                              color: '壬癸'.contains(widget.result.tianpan[indexed[0]]!) ? const Color(0xffc0281c)
                                                                  : '辛壬'.contains(widget.result.tianpan[indexed[0]]!) ? const Color(0xff3371ca)
                                                                  : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.shen[indexed[0]]!,
                                                            style: TextStyle(
                                                              color: '虎' == widget.result.shen[indexed[0]]! ? const Color(0xfff1ac62) : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      widget.result.men[indexed[0]]!.substring(0, 1),
                                                      style: TextStyle(
                                                        color: '开惊'.contains(widget.result.men[indexed[0]]!.substring(0, 1)) ? const Color(0xffff6f00) : const Color(0xff222426),
                                                        fontSize: 30.sp,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.dipan[indexed[0]] ?? '',
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.xing[indexed[0]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: Text(
                                                      '巽',
                                                      style: TextStyle(
                                                        color: (widget.kong.contains('辰') || widget.kong.contains('巳')) ? const Color(0xff3371ca) : const Color(0xffcccccc),
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w900,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              height: 180.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 10.w),
                                              color: const Color(0xfff6f6f6),
                                              child: Stack(
                                                children: [
                                                  Visibility(
                                                    visible: '午' == ShenShaUtil.OTHER_DAY_BRANCH['日马']![widget.branch]!.join(''),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10.w, right: 10.w),
                                                        child: SvgPicture.asset(
                                                          'assets/svgs/horse.svg',
                                                          width: 26.w,
                                                          height: 20.w,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.tianpan[indexed[1]] ?? '',
                                                            style: TextStyle(
                                                              color: '辛' == widget.result.tianpan[indexed[1]]! ? const Color(0xffc0281c)
                                                                  :  const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.shen[indexed[1]]!,
                                                            style: TextStyle(
                                                              color: '虎' == widget.result.shen[indexed[1]]! ? const Color(0xfff1ac62) : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      widget.result.men[indexed[1]]!.substring(0, 1),
                                                      style: TextStyle(
                                                        color: widget.result.men[indexed[1]]!.substring(0, 1) == '休' ? const Color(0xffff6f00) : const Color(0xff222426),
                                                        fontSize: 30.sp,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.dipan[indexed[1]] ?? '',
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.xing[indexed[1]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Text(
                                                      '离',
                                                      style: TextStyle(
                                                        color: widget.kong.contains('午') ? const Color(0xff3371ca) : const Color(0xffcccccc),
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w900,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              height: 180.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 10.w),
                                              color: const Color(0xfff6f6f6),
                                              child: Stack(
                                                children: [
                                                  Visibility(
                                                    visible: '未申'.contains(ShenShaUtil.OTHER_DAY_BRANCH['日马']![widget.branch]!.join('')),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10.w, right: 10.w),
                                                        child: SvgPicture.asset(
                                                          'assets/svgs/horse.svg',
                                                          width: 26.w,
                                                          height: 20.w,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.tianpan[indexed[2]] ?? '',
                                                            style: TextStyle(
                                                              color: '己' == widget.result.tianpan[indexed[2]]! ? const Color(0xffc0281c)
                                                                  : '甲癸'.contains(widget.result.tianpan[indexed[2]]!) ? const Color(0xff3371ca)
                                                                  :  const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.shen[indexed[2]]!,
                                                            style: TextStyle(
                                                              color: '虎' == widget.result.shen[indexed[2]]! ? const Color(0xfff1ac62) : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      widget.result.men[indexed[2]]!.substring(0, 1),
                                                      style: TextStyle(
                                                        color: '伤杜'.contains(widget.result.men[indexed[2]]!.substring(0, 1)) ? const Color(0xffff6f00) : const Color(0xff222426),
                                                        fontSize: 30.sp,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.dipan[indexed[2]] ?? '',
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.xing[indexed[2]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Text(
                                                      '坤',
                                                      style: TextStyle(
                                                        color: (widget.kong.contains('未') || widget.kong.contains('申')) ? const Color(0xff3371ca) : const Color(0xffcccccc),
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w900,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              height: 180.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 10.w),
                                              color: const Color(0xfff6f6f6),
                                              child: Stack(
                                                children: [
                                                  Visibility(
                                                    visible: '卯' == ShenShaUtil.OTHER_DAY_BRANCH['日马']![widget.branch]!.join(''),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10.w, right: 10.w),
                                                        child: SvgPicture.asset(
                                                          'assets/svgs/horse.svg',
                                                          width: 26.w,
                                                          height: 20.w,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.tianpan[indexed[7]] ?? '',
                                                            style: TextStyle(
                                                              color: '戊' == widget.result.tianpan[indexed[7]]! ? const Color(0xffc0281c)
                                                                  : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.shen[indexed[7]]!,
                                                            style: TextStyle(
                                                              color: '虎' == widget.result.shen[indexed[7]]! ? const Color(0xfff1ac62) : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      widget.result.men[indexed[7]]!.substring(0, 1),
                                                      style: TextStyle(
                                                        color: '开惊'.contains(widget.result.men[indexed[7]]!.substring(0, 1)) ? const Color(0xffff6f00) : const Color(0xff222426),
                                                        fontSize: 30.sp,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.dipan[indexed[7]] ?? '',
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.xing[indexed[7]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      '震',
                                                      style: TextStyle(
                                                        color: widget.kong.contains('卯') ? const Color(0xff3371ca) : const Color(0xffcccccc),
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w900,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          TableCell(
                                            child: Container(
                                              height: 180.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 10.w),
                                              color: const Color(0xfff6f6f6),
                                              child: Center(
                                                child: Text(
                                                  widget.result.dipan['5'] ?? '',
                                                  style: TextStyle(
                                                    color: const Color(0xffcccccc),
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          TableCell(
                                            child: Container(
                                              height: 180.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 10.w),
                                              color: const Color(0xfff6f6f6),
                                              child: Stack(
                                                children: [
                                                  Visibility(
                                                    visible: '酉' == ShenShaUtil.OTHER_DAY_BRANCH['日马']![widget.branch]!.join(''),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10.w, right: 10.w),
                                                        child: SvgPicture.asset(
                                                          'assets/svgs/horse.svg',
                                                          width: 26.w,
                                                          height: 20.w,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.tianpan[indexed[3]] ?? '',
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.shen[indexed[3]]!,
                                                            style: TextStyle(
                                                              color: '虎' == widget.result.shen[indexed[3]]! ? const Color(0xfff1ac62) : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      widget.result.men[indexed[3]]!.substring(0, 1),
                                                      style: TextStyle(
                                                        color: '景' == widget.result.men[indexed[3]]!.substring(0, 1)
                                                            ? const Color(0xffff6f00)
                                                            : const Color(0xff222426),
                                                        fontSize: 30.sp,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.dipan[indexed[3]]!.substring(0, 1),
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.xing[indexed[3]]!.substring(0, 1),
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      '兑',
                                                      style: TextStyle(
                                                        color: widget.kong.contains('酉') ? const Color(0xff3371ca) : const Color(0xffcccccc),
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w900,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              height: 180.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 10.w),
                                              color: const Color(0xfff6f6f6),
                                              child: Stack(
                                                children: [
                                                  Visibility(
                                                    visible: '寅丑'.contains(ShenShaUtil.OTHER_DAY_BRANCH['日马']![widget.branch]!.join('')),
                                                    child: Align(
                                                      alignment: Alignment.bottomLeft,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(bottom: 10.w, left: 10.w),
                                                        child: SvgPicture.asset(
                                                          'assets/svgs/horse.svg',
                                                          width: 26.w,
                                                          height: 20.w,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.tianpan[indexed[6]] ?? '',
                                                            style: TextStyle(
                                                              color: '庚' == widget.result.tianpan[indexed[6]]! ? const Color(0xffc0281c)
                                                                  : '丁己庚'.contains(widget.result.tianpan[indexed[6]]!) ? const Color(0xff3371ca)
                                                                  : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.shen[indexed[6]]!,
                                                            style: TextStyle(
                                                              color: '虎' == widget.result.shen[indexed[6]]! ? const Color(0xfff1ac62) : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      widget.result.men[indexed[6]]!.substring(0, 1),
                                                      style: TextStyle(
                                                        color: '伤杜'.contains(widget.result.men[indexed[6]]!.substring(0, 1))
                                                            ? const Color(0xffff6f00)
                                                            : const Color(0xff222426),
                                                        fontSize: 30.sp,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.dipan[indexed[6]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.xing[indexed[6]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topRight,
                                                    child: Text(
                                                      '艮',
                                                      style: TextStyle(
                                                        color: (widget.kong.contains('丑') || widget.kong.contains('寅')) ? const Color(0xff3371ca) : const Color(0xffcccccc),
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w900,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          TableCell(
                                            child: Container(
                                              height: 180.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 10.w),
                                              color: const Color(0xfff6f6f6),
                                              child: Stack(
                                                children: [
                                                  Visibility(
                                                    visible: '子' == ShenShaUtil.OTHER_DAY_BRANCH['日马']![widget.branch]!.join(''),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10.w, right: 10.w),
                                                        child: SvgPicture.asset(
                                                          'assets/svgs/horse.svg',
                                                          width: 26.w,
                                                          height: 20.w,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.tianpan[indexed[5]] ?? '',
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.shen[indexed[5]]!,
                                                            style: TextStyle(
                                                              color: '虎' == widget.result.shen[indexed[5]]! ? const Color(0xfff1ac62) : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      widget.result.men[indexed[5]]!.substring(0, 1),
                                                      style: TextStyle(
                                                        color: '生死'.contains(widget.result.men[indexed[5]]!.substring(0, 1))
                                                            ? const Color(0xffff6f00)
                                                            : const Color(0xff222426),
                                                        fontSize: 30.sp,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.dipan[indexed[5]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.xing[indexed[5]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Text(
                                                      '坎',
                                                      style: TextStyle(
                                                        color: widget.kong.contains('子') ? const Color(0xff3371ca) : const Color(0xffcccccc),
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w900,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          TableCell(
                                            child: Container(
                                              height: 180.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 10.w),
                                              color: const Color(0xfff6f6f6),
                                              child: Stack(
                                                children: [
                                                  Visibility(
                                                    visible: '戌亥'.contains(ShenShaUtil.OTHER_DAY_BRANCH['日马']![widget.branch]!.join('')),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.only(top: 10.w, right: 10.w),
                                                        child: SvgPicture.asset(
                                                          'assets/svgs/horse.svg',
                                                          width: 26.w,
                                                          height: 20.w,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.tianpan[indexed[4]] ?? '',
                                                            style: TextStyle(
                                                              color: '乙丙戊'.contains(widget.result.tianpan[indexed[4]]!) ? const Color(0xff3371ca) : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.shen[indexed[4]]!,
                                                            style: TextStyle(
                                                              color: '虎' == widget.result.shen[indexed[4]]! ? const Color(0xfff1ac62) : const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      widget.result.men[indexed[4]]!.substring(0, 1),
                                                      style: TextStyle(
                                                        color: '景' == widget.result.men[indexed[4]]!.substring(0, 1) ? const Color(0xffff6f00) : const Color(0xff222426),
                                                        fontSize: 30.sp,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(bottom: 32.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            widget.result.dipan[indexed[4]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            widget.result.xing[indexed[4]]!,
                                                            style: TextStyle(
                                                              color: const Color(0xff393b41),
                                                              fontSize: 24.sp,
                                                              fontWeight: FontWeight.w700,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      '乾',
                                                      style: TextStyle(
                                                        color: (widget.kong.contains('戌') || widget.kong.contains('亥')) ? const Color(0xff3371ca) : const Color(0xffcccccc),
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w900,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: widget.seal == 1,
                              child: Positioned.fill(
                                child: Opacity(
                                  opacity: 0.25,
                                  child: Image.asset('assets/images/sealed.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      index == 7
                          ? SizedBox(width: 32.w)
                          : GestureDetector(
                        onTap: () {
                          setState(() {
                            index += 1;
                            List<String> result = [];
                            for (String element in indexed) {
                              String ele = list.find(element)!.prev!.data;
                              result.add(ele);
                              Log.d('顺转 >>>> $ele');
                            }
                            indexed = result;
                          });
                        },
                        child: Container(
                          width: 32.w,
                          height: 56.w,
                          color: Colors.white,
                          child: Transform.scale(
                            scaleX: -1,
                            child: SvgPicture.asset(
                              'assets/icons/arrow-left.svg',
                              width: 32.w,
                              height: 56.w,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
