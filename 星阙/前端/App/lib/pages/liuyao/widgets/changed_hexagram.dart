import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/liu_lines.dart';
import 'single_hexagram.dart';

/// 变卦
class ChangedHexagram extends StatelessWidget {
  const ChangedHexagram({super.key, required this.hexagrams});

  final LiuYaoResult hexagrams;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
      columnWidths: {
        0: FixedColumnWidth(94.w),
        1: FixedColumnWidth(6.w),
        3: FixedColumnWidth(24.w),
      },
      children: [
        TableRow(
          children: [
            const TableCell(child: SizedBox()),
            const TableCell(child: SizedBox()),
            TableCell(
              child: Padding(
                padding: EdgeInsets.only(left: 32.w),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: hexagrams.gua.name,
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: '${hexagrams.gua.gong}${hexagrams.gua.gua.isEmpty ? '' : '(${hexagrams.gua.gua})'}${hexagrams.gua.he.isEmpty ? '' : '(${hexagrams.gua.he})'}',
                        style: TextStyle(
                          color: const Color(0xFFCCCCCC),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const TableCell(child: SizedBox()),
            TableCell(
              child: Padding(
                padding: EdgeInsets.only(left: 32.w),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: hexagrams.changeGua!.name,
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: '${hexagrams.changeGua!.gong}${hexagrams.changeGua!.gua.isEmpty ? '' : '(${hexagrams.changeGua!.gua})'}${hexagrams.changeGua!.he.isEmpty ? '' : '(${hexagrams.changeGua!.he})'}',
                        style: TextStyle(
                          color: const Color(0xFFCCCCCC),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Row(
                  children: [
                    Text(
                      hexagrams.gua.liushou[5],
                      style: TextStyle(
                        color: const Color(0xfff1ac62),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      hexagrams.gua.fushen.firstWhere((ele) => ele.index == 5, orElse: () => GuaFushen(index: -1, name: '')).name,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: const Color(0xffcccccc),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
              line: hexagrams.gua.value.split('')[5],
              relatives: hexagrams.gua.liuqin[5],
              stems: hexagrams.gua.tiangan[5],
              branch: hexagrams.gua.dizhi[5],
              shiOrYing: hexagrams.gua.shi == 5 ? '世' : hexagrams.gua.ying == 5 ? '应' : '',
            )),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
                  isHighLight: ['6', '9'].contains(hexagrams.gua.value.split('')[5]),
              line: hexagrams.changeGua!.value.split('')[5],
              relatives: hexagrams.changeGua!.liuqin[5],
              stems: hexagrams.changeGua!.tiangan[5],
              branch: hexagrams.changeGua!.dizhi[5],
              shiOrYing: hexagrams.changeGua!.shi == 5 ? '世' : hexagrams.changeGua!.ying == 5 ? '应' : '',
            )),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Row(
                  children: [
                    Text(
                      hexagrams.gua.liushou[4],
                      style: TextStyle(
                        color: const Color(0xfff1ac62),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      hexagrams.gua.fushen.firstWhere((ele) => ele.index == 4, orElse: () => GuaFushen(index: -1, name: '')).name,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: const Color(0xffcccccc),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
              line: hexagrams.gua.value.split('')[4],
              relatives: hexagrams.gua.liuqin[4],
              stems: hexagrams.gua.tiangan[4],
              branch: hexagrams.gua.dizhi[4],
              shiOrYing: hexagrams.gua.shi == 4 ? '世' : hexagrams.gua.ying == 4 ? '应' : '',
            )),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
                  isHighLight: ['6', '9'].contains(hexagrams.gua.value.split('')[4]),
              line: hexagrams.changeGua!.value.split('')[4],
              relatives: hexagrams.changeGua!.liuqin[4],
              stems: hexagrams.changeGua!.tiangan[4],
              branch: hexagrams.changeGua!.dizhi[4],
              shiOrYing: hexagrams.changeGua!.shi == 4 ? '世' : hexagrams.changeGua!.ying == 4 ? '应' : '',
            )),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Row(
                  children: [
                    Text(
                      hexagrams.gua.liushou[3],
                      style: TextStyle(
                        color: const Color(0xfff1ac62),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      hexagrams.gua.fushen.firstWhere((ele) => ele.index == 3, orElse: () => GuaFushen(index: -1, name: '')).name,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: const Color(0xffcccccc),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
              line: hexagrams.gua.value.split('')[3],
              relatives: hexagrams.gua.liuqin[3],
              stems: hexagrams.gua.tiangan[3],
              branch: hexagrams.gua.dizhi[3],
              shiOrYing: hexagrams.gua.shi == 3 ? '世' : hexagrams.gua.ying == 3 ? '应' : '',
            )),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
                  isHighLight: ['6', '9'].contains(hexagrams.gua.value.split('')[3]),
              line: hexagrams.changeGua!.value.split('')[3],
              relatives: hexagrams.changeGua!.liuqin[3],
              stems: hexagrams.changeGua!.tiangan[3],
              branch: hexagrams.changeGua!.dizhi[3],
              shiOrYing: hexagrams.changeGua!.shi == 3 ? '世' : hexagrams.changeGua!.ying == 3 ? '应' : '',
            )),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Row(
                  children: [
                    Text(
                      hexagrams.gua.liushou[2],
                      style: TextStyle(
                        color: const Color(0xfff1ac62),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      hexagrams.gua.fushen.firstWhere((ele) => ele.index == 2, orElse: () => GuaFushen(index: -1, name: '')).name,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: const Color(0xffcccccc),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
              line: hexagrams.gua.value.split('')[2],
              relatives: hexagrams.gua.liuqin[2],
              stems: hexagrams.gua.tiangan[2],
              branch: hexagrams.gua.dizhi[2],
              shiOrYing: hexagrams.gua.shi == 2 ? '世' : hexagrams.gua.ying == 2 ? '应' : '',
            )),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
                  isHighLight: ['6', '9'].contains(hexagrams.gua.value.split('')[2]),
              line: hexagrams.changeGua!.value.split('')[2],
              relatives: hexagrams.changeGua!.liuqin[2],
              stems: hexagrams.changeGua!.tiangan[2],
              branch: hexagrams.changeGua!.dizhi[2],
              shiOrYing: hexagrams.changeGua!.shi == 2 ? '世' : hexagrams.changeGua!.ying == 2 ? '应' : '',
            )),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Row(
                  children: [
                    Text(
                      hexagrams.gua.liushou[1],
                      style: TextStyle(
                        color: const Color(0xfff1ac62),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      hexagrams.gua.fushen.firstWhere((ele) => ele.index == 1, orElse: () => GuaFushen(index: -1, name: '')).name,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: const Color(0xffcccccc),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
              line: hexagrams.gua.value.split('')[1],
              relatives: hexagrams.gua.liuqin[1],
              stems: hexagrams.gua.tiangan[1],
              branch: hexagrams.gua.dizhi[1],
              shiOrYing: hexagrams.gua.shi == 1 ? '世' : hexagrams.gua.ying == 1 ? '应' : '',
            )),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
                  isHighLight: ['6', '9'].contains(hexagrams.gua.value.split('')[1]),
              line: hexagrams.changeGua!.value.split('')[1],
              relatives: hexagrams.changeGua!.liuqin[1],
              stems: hexagrams.changeGua!.tiangan[1],
              branch: hexagrams.changeGua!.dizhi[1],
              shiOrYing: hexagrams.changeGua!.shi == 1 ? '世' : hexagrams.changeGua!.ying == 1 ? '应' : '',
            )),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Row(
                  children: [
                    Text(
                      hexagrams.gua.liushou[0],
                      style: TextStyle(
                        color: const Color(0xfff1ac62),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      hexagrams.gua.fushen.firstWhere((ele) => ele.index == 0, orElse: () => GuaFushen(index: -1, name: '')).name,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: const Color(0xffcccccc),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
              line: hexagrams.gua.value.split('')[0],
              relatives: hexagrams.gua.liuqin[0],
              stems: hexagrams.gua.tiangan[0],
              branch: hexagrams.gua.dizhi[0],
              shiOrYing: hexagrams.gua.shi == 0 ? '世' : hexagrams.gua.ying == 0 ? '应' : '',
            )),
            const TableCell(child: SizedBox()),
            TableCell(
                child: SingleHexagram(
                  isHighLight: ['6', '9'].contains(hexagrams.gua.value.split('')[0]),
                  line: hexagrams.changeGua!.value.split('')[0],
                  relatives: hexagrams.changeGua!.liuqin[0],
                  stems: hexagrams.changeGua!.tiangan[0],
                  branch: hexagrams.changeGua!.dizhi[0],
                  shiOrYing: hexagrams.changeGua!.shi == 0 ? '世' : hexagrams.changeGua!.ying == 0 ? '应' : '',
                ),
            ),
          ],
        ),
      ],
    );
  }
}
