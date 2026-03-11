import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/liu_lines.dart';
import 'single_hexagram.dart';

/// 无变卦
class NonChangedHexagram extends StatelessWidget {
  const NonChangedHexagram({super.key, required this.hexagrams});

  final LiuYaoResult hexagrams;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 0.5.sw,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
          columnWidths: {
            0: FixedColumnWidth(94.w),
            1: FixedColumnWidth(6.w),
          },
          children: [
            TableRow(
              children: [
                const TableCell(child: SizedBox()),
                const TableCell(child: SizedBox()),
                TableCell(
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
                      ],
                    ),
                  ),
                ),
                const TableCell(child: SizedBox()),
                TableCell(child: SingleHexagram(
                  line: hexagrams.gua.value.split('')[5],
                  relatives: hexagrams.gua.liuqin[5],
                  stems: hexagrams.gua.tiangan[5],
                  branch: hexagrams.gua.dizhi[5],
                  shiOrYing: hexagrams.gua.shi == 5 ? '世' : hexagrams.gua.ying == 5 ? '应' : '',
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
                      ],
                    ),
                  ),
                ),
                const TableCell(child: SizedBox()),
                TableCell(child: SingleHexagram(
                  line: hexagrams.gua.value.split('')[4],
                  relatives: hexagrams.gua.liuqin[4],
                  stems: hexagrams.gua.tiangan[4],
                  branch: hexagrams.gua.dizhi[4],
                  shiOrYing: hexagrams.gua.shi == 4 ? '世' : hexagrams.gua.ying == 4 ? '应' : '',
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
                      ],
                    ),
                  ),
                ),
                const TableCell(child: SizedBox()),
                TableCell(child: SingleHexagram(
                  line: hexagrams.gua.value.split('')[3],
                  relatives: hexagrams.gua.liuqin[3],
                  stems: hexagrams.gua.tiangan[3],
                  branch: hexagrams.gua.dizhi[3],
                  shiOrYing: hexagrams.gua.shi == 3 ? '世' : hexagrams.gua.ying == 3 ? '应' : '',
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
                        )
                      ],
                    ),
                  ),
                ),
                const TableCell(child: SizedBox()),
                TableCell(child: SingleHexagram(
                  line: hexagrams.gua.value.split('')[2],
                  relatives: hexagrams.gua.liuqin[2],
                  stems: hexagrams.gua.tiangan[2],
                  branch: hexagrams.gua.dizhi[2],
                  shiOrYing: hexagrams.gua.shi == 2 ? '世' : hexagrams.gua.ying == 2 ? '应' : '',
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
                      ],
                    ),
                  ),
                ),
                const TableCell(child: SizedBox()),
                TableCell(child: SingleHexagram(
                  line: hexagrams.gua.value.split('')[1],
                  relatives: hexagrams.gua.liuqin[1],
                  stems: hexagrams.gua.tiangan[1],
                  branch: hexagrams.gua.dizhi[1],
                  shiOrYing: hexagrams.gua.shi == 1 ? '世' : hexagrams.gua.ying == 1 ? '应' : '',
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
                      ],
                    ),
                  ),
                ),
                const TableCell(child: SizedBox()),
                TableCell(child: SingleHexagram(
                  line: hexagrams.gua.value.split('')[0],
                  relatives: hexagrams.gua.liuqin[0],
                  stems: hexagrams.gua.tiangan[0],
                  branch: hexagrams.gua.dizhi[0],
                  shiOrYing: hexagrams.gua.shi == 0 ? '世' : hexagrams.gua.ying == 0 ? '应' : '',
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
